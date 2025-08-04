use std::cell::RefCell;
use std::f64::consts::PI;
use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};

/// Colors for drawing
const COLOR_BG: &str = "#000000";
const COLOR_FG: &str = "#ffffff";

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
            iterations: self.iterations.clamp(1, 15),
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
    is_running: bool,
}

thread_local! {
    static STATE: RefCell<AppState> = RefCell::new(AppState {
        params: FractalParams { iterations: 5, angle: 25.0, length: 100.0 },
        canvas_context: None,
        canvas_size: (800.0, 600.0),
        is_running: false,
    });
}

#[wasm_bindgen]
pub fn init_fractal_trees(canvas_id: &str) -> Result<(), JsValue> {
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

#[wasm_bindgen]
pub fn start_fractal_trees() {
    STATE.with(|state| {
        state.borrow_mut().is_running = true;
    });
    draw_fractal_tree();
}

#[wasm_bindgen]
pub fn stop_fractal_trees() {
    STATE.with(|state| {
        state.borrow_mut().is_running = false;
    });
    clear_canvas();
}

#[wasm_bindgen]
pub fn update_fractal_params(iterations: i32, angle: f32, length: f32) {
    let should_draw = STATE.with(|state| {
        let mut s = state.borrow_mut();
        s.params = FractalParams {
            iterations,
            angle,
            length,
        }
        .clamp();

        s.is_running
    });

    if should_draw {
        draw_fractal_tree();
    }
}

fn clear_canvas() {
    STATE.with(|state| {
        let s = state.borrow();
        if let Some(ctx) = &s.canvas_context {
            let (width, height) = s.canvas_size;
            ctx.set_fill_style(&COLOR_BG.into());
            ctx.fill_rect(0.0, 0.0, width, height);
        }
    });
}

fn draw_fractal_tree() {
    STATE.with(|state| {
        let s = state.borrow();
        if let Some(ctx) = &s.canvas_context {
            let (width, height) = s.canvas_size;
            let p = s.params;

            // Clear background
            ctx.set_fill_style(&COLOR_BG.into());
            ctx.fill_rect(0.0, 0.0, width, height);

            // Draw tree
            ctx.set_stroke_style(&COLOR_FG.into());
            ctx.set_line_cap("round");
            draw_tree(
                ctx,
                width / 2.0,
                height - 20.0,
                -90.0,
                p.length as f64,
                p.iterations,
                p.angle as f64,
            );
        }
    });
}

fn draw_tree(
    ctx: &CanvasRenderingContext2d,
    x: f64,
    y: f64,
    angle_deg: f64,
    length: f64,
    depth: i32,
    branch_angle: f64,
) {
    if depth == 0 {
        return;
    }

    let angle_rad = angle_deg.to_radians();
    let end_x = x + length * angle_rad.cos();
    let end_y = y + length * angle_rad.sin();

    ctx.set_line_width((depth as f64 * 0.8).max(1.0));
    ctx.begin_path();
    ctx.move_to(x, y);
    ctx.line_to(end_x, end_y);
    ctx.stroke();

    if depth > 1 {
        let new_length = length * 0.75;
        draw_tree(
            ctx,
            end_x,
            end_y,
            angle_deg - branch_angle,
            new_length,
            depth - 1,
            branch_angle,
        );
        draw_tree(
            ctx,
            end_x,
            end_y,
            angle_deg + branch_angle,
            new_length,
            depth - 1,
            branch_angle,
        );
    }
}

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}
