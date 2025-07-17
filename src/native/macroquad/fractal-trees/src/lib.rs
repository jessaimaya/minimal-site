use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};
use std::f64;
use std::cell::RefCell;

// Safe global state using thread-local storage
thread_local! {
    static PARAMS: RefCell<(i32, f32, f32)> = RefCell::new((5, 25.0, 100.0));
    static CANVAS_CONTEXT: RefCell<Option<CanvasRenderingContext2d>> = RefCell::new(None);
    static CANVAS_SIZE: RefCell<(f64, f64)> = RefCell::new((800.0, 600.0));
}


#[wasm_bindgen]
pub fn init_fractal_trees(canvas_id: &str) {
    
    let window = web_sys::window().unwrap();
    let document = window.document().unwrap();
    let canvas = document
        .get_element_by_id(canvas_id)
        .unwrap()
        .dyn_into::<HtmlCanvasElement>()
        .unwrap();
    
    let context = canvas
        .get_context("2d")
        .unwrap()
        .unwrap()
        .dyn_into::<CanvasRenderingContext2d>()
        .unwrap();
    
    CANVAS_CONTEXT.with(|ctx| {
        *ctx.borrow_mut() = Some(context);
    });
    
    CANVAS_SIZE.with(|size| {
        *size.borrow_mut() = (canvas.width() as f64, canvas.height() as f64);
    });
}

#[wasm_bindgen]
pub fn start_fractal_trees() {
    draw_fractal_tree();
}

#[wasm_bindgen]
pub fn stop_fractal_trees() {
    clear_canvas();
}

#[wasm_bindgen]
pub fn update_fractal_params(iterations: i32, angle: f32, length: f32) {
    PARAMS.with(|params| {
        let mut p = params.borrow_mut();
        p.0 = iterations.clamp(1, 15);
        p.1 = angle.clamp(5.0, 60.0);
        p.2 = length.clamp(20.0, 200.0);
    });
    draw_fractal_tree();
}

fn clear_canvas() {
    CANVAS_CONTEXT.with(|ctx_ref| {
        CANVAS_SIZE.with(|size_ref| {
            if let Some(ctx) = ctx_ref.borrow().as_ref() {
                let (width, height) = *size_ref.borrow();
                ctx.set_fill_style(&"#000000".into());
                ctx.fill_rect(0.0, 0.0, width, height);
            }
        });
    });
}

fn draw_fractal_tree() {
    CANVAS_CONTEXT.with(|ctx_ref| {
        CANVAS_SIZE.with(|size_ref| {
            PARAMS.with(|params_ref| {
                if let Some(ctx) = ctx_ref.borrow().as_ref() {
                    let (width, height) = *size_ref.borrow();
                    let (iterations, angle, length) = *params_ref.borrow();
                    
                    // Clear canvas
                    ctx.set_fill_style(&"#000000".into());
                    ctx.fill_rect(0.0, 0.0, width, height);
                    
                    // Set drawing style
                    ctx.set_stroke_style(&"#ffffff".into());
                    ctx.set_line_cap("round");
                    
                    // Draw the tree
                    draw_tree(
                        ctx,
                        width / 2.0,
                        height - 20.0,
                        -90.0,
                        length as f64,
                        iterations,
                        angle as f64,
                    );
                }
            });
        });
    });
}

fn draw_tree(
    ctx: &CanvasRenderingContext2d,
    x: f64,
    y: f64,
    angle: f64,
    length: f64,
    depth: i32,
    branch_angle: f64,
) {
    if depth == 0 {
        return;
    }
    
    let angle_rad = angle * f64::consts::PI / 180.0;
    let end_x = x + length * angle_rad.cos();
    let end_y = y + length * angle_rad.sin();
    
    // Set line width based on depth
    let line_width = (depth as f64 * 0.8).max(1.0);
    ctx.set_line_width(line_width);
    
    // Draw the branch
    ctx.begin_path();
    ctx.move_to(x, y);
    ctx.line_to(end_x, end_y);
    ctx.stroke();
    
    // Draw recursive branches
    if depth > 1 {
        let new_length = length * 0.75;
        draw_tree(ctx, end_x, end_y, angle - branch_angle, new_length, depth - 1, branch_angle);
        draw_tree(ctx, end_x, end_y, angle + branch_angle, new_length, depth - 1, branch_angle);
    }
}

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}