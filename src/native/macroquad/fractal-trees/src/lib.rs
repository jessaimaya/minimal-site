use std::cell::RefCell;
use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};

/// Lengths are authored against a 720x600 canvas and scaled to fit the real one
const REFERENCE_WIDTH: f64 = 720.0;
const REFERENCE_HEIGHT: f64 = 600.0;

/// Parameters controlling the fractal tree
#[derive(Clone, Copy)]
struct FractalParams {
    iterations: i32,
    angle: f32,
    length: f32,
}

impl FractalParams {
    fn clamp(self) -> Self {
        Self {
            iterations: self.iterations.clamp(1, 13),
            angle: self.angle.clamp(5.0, 60.0),
            length: self.length.clamp(20.0, 200.0),
        }
    }
}

/// Application state stored in thread-local storage for wasm
struct AppState {
    params: FractalParams,
    canvas_context: Option<CanvasRenderingContext2d>,
    canvas_size: (f64, f64),
    time: f64,
    /// Colours to blend through from trunk to tips, as RGB
    palette: Vec<Rgb>,
}

type Rgb = [f64; 3];

/// Used until the page sends the site palette: slate from src/data/palette.ts
const FALLBACK: Rgb = [173.0, 181.0, 187.0];

thread_local! {
    static STATE: RefCell<AppState> = RefCell::new(AppState {
        params: FractalParams { iterations: 10, angle: 25.0, length: 140.0 },
        canvas_context: None,
        canvas_size: (800.0, 600.0),
        time: 0.0,
        palette: vec![FALLBACK],
    });
}

// Every experiment exposes the same functions to the page:
// `setup`, `frame`, `set_param` and, when it uses colour, `set_palette`.

/// Binds the canvas. Call again after resizing it so the new size is picked up.
#[wasm_bindgen]
pub fn setup(canvas_id: &str) -> Result<(), JsValue> {
    let window = web_sys::window().ok_or("No global `window` found")?;
    let document = window.document().ok_or("No document found")?;
    let canvas = document
        .get_element_by_id(canvas_id)
        .ok_or("Canvas element not found")?
        .dyn_into::<HtmlCanvasElement>()?;

    let context = canvas
        .get_context("2d")?
        .ok_or("Could not get 2D context")?
        .dyn_into::<CanvasRenderingContext2d>()?;

    STATE.with(|state| {
        let mut s = state.borrow_mut();
        s.canvas_context = Some(context);
        s.canvas_size = (canvas.width() as f64, canvas.height() as f64);
    });

    Ok(())
}

/// Draws the tree at `time` seconds: branches sway and the palette drifts
#[wasm_bindgen]
pub fn frame(time: f64) {
    STATE.with(|state| state.borrow_mut().time = time);
    draw();
}

/// Sets one control by name (`iterations`, `angle` or `length`) and redraws
#[wasm_bindgen]
pub fn set_param(name: &str, value: f64) {
    STATE.with(|state| {
        let mut s = state.borrow_mut();
        let mut p = s.params;
        match name {
            "iterations" => p.iterations = value.round() as i32,
            "angle" => p.angle = value as f32,
            "length" => p.length = value as f32,
            _ => return,
        }
        s.params = p.clamp();
    });
    draw();
}

/// Sets the colours to blend through, as comma separated hex (`#5EA8E6,#C387C2`)
#[wasm_bindgen]
pub fn set_palette(colors: &str) {
    let parsed: Vec<Rgb> = colors.split(',').filter_map(parse_hex).collect();
    if parsed.is_empty() {
        return;
    }
    STATE.with(|state| state.borrow_mut().palette = parsed);
    draw();
}

fn parse_hex(hex: &str) -> Option<Rgb> {
    let hex = hex.trim().trim_start_matches('#');
    if hex.len() != 6 {
        return None;
    }
    let value = u32::from_str_radix(hex, 16).ok()?;
    Some([
        ((value >> 16) & 0xff) as f64,
        ((value >> 8) & 0xff) as f64,
        (value & 0xff) as f64,
    ])
}

/// Colour at `t` (0 to 1) along the palette, blending neighbours linearly
fn sample(palette: &[Rgb], t: f64) -> Rgb {
    let last = palette.len() - 1;
    let position = t.clamp(0.0, 1.0) * last as f64;
    let index = (position.floor() as usize).min(last);
    let next = (index + 1).min(last);
    let mix = position - index as f64;
    let [a, b] = [palette[index], palette[next]];
    [0, 1, 2].map(|i| a[i] + (b[i] - a[i]) * mix)
}

fn draw() {
    STATE.with(|state| {
        let s = state.borrow();
        let Some(ctx) = &s.canvas_context else { return };
        let (width, height) = s.canvas_size;
        let p = s.params;

        // Transparent background, so the page shows through in both themes
        ctx.clear_rect(0.0, 0.0, width, height);
        ctx.set_line_cap("round");

        // One stroke colour per depth, trunk first, so branches don't format strings
        let levels = (p.iterations - 1).max(1) as f64;
        let colors = (0..p.iterations)
            .map(|level| {
                let t = level as f64 / levels;
                let [r, g, b] = sample(&s.palette, t);
                format!("rgba({r:.0}, {g:.0}, {b:.0}, {:.2})", 1.0 - t * 0.25)
            })
            .collect();

        let tree = Tree {
            ctx,
            colors,
            scale: (height / REFERENCE_HEIGHT).min(width / REFERENCE_WIDTH),
            branch_angle: p.angle as f64,
            iterations: p.iterations,
            time: s.time,
        };
        // Grow from the bottom of the reference box, centred in the canvas
        tree.branch(
            width / 2.0,
            (height + REFERENCE_HEIGHT * tree.scale) / 2.0,
            -90.0,
            p.length as f64 * tree.scale,
            p.iterations,
        );
    });
}

struct Tree<'a> {
    ctx: &'a CanvasRenderingContext2d,
    colors: Vec<String>,
    scale: f64,
    branch_angle: f64,
    iterations: i32,
    time: f64,
}

impl Tree<'_> {
    fn branch(&self, x: f64, y: f64, angle_deg: f64, length: f64, depth: i32) {
        if depth == 0 {
            return;
        }

        // 0 at the trunk, 1 at the outermost twigs
        let level = (self.iterations - depth) as f64 / (self.iterations - 1).max(1) as f64;

        // Outer branches move more, each level slightly out of phase
        let sway = (self.time * 0.9 + level * 3.0).sin() * 3.0 * level;
        let angle_rad = (angle_deg + sway).to_radians();
        let end_x = x + length * angle_rad.cos();
        let end_y = y + length * angle_rad.sin();

        self.ctx
            .set_stroke_style_str(&self.colors[(self.iterations - depth) as usize]);
        self.ctx
            .set_line_width((depth as f64 * 1.1 * self.scale).max(0.8));
        self.ctx.begin_path();
        self.ctx.move_to(x, y);
        self.ctx.line_to(end_x, end_y);
        self.ctx.stroke();

        let new_length = length * 0.75;
        self.branch(end_x, end_y, angle_deg + sway - self.branch_angle, new_length, depth - 1);
        self.branch(end_x, end_y, angle_deg + sway + self.branch_angle, new_length, depth - 1);
    }
}

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}
