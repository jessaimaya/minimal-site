use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};
use std::f64;

static mut PARAMS: (i32, f32, f32) = (5, 25.0, 100.0); // customize parameters
static mut CANVAS_CONTEXT: Option<CanvasRenderingContext2d> = None;
static mut CANVAS_WIDTH: f64 = 800.0;
static mut CANVAS_HEIGHT: f64 = 600.0;

#[wasm_bindgen]
pub fn init_starfield(canvas_id: &str) {
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
    
    unsafe {
        CANVAS_CONTEXT = Some(context);
        CANVAS_WIDTH = canvas.width() as f64;
        CANVAS_HEIGHT = canvas.height() as f64;
    }
}

#[wasm_bindgen]
pub fn start_starfield() {
    draw_graphics();
}

#[wasm_bindgen]
pub fn stop_starfield() {
    clear_canvas();
}

#[wasm_bindgen]
pub fn update_starfield_params(param1: i32, param2: f32, param3: f32) {
    unsafe {
        PARAMS.0 = param1.clamp(1, 20);
        PARAMS.1 = param2.clamp(0.0, 100.0);
        PARAMS.2 = param3.clamp(10.0, 500.0);
    }
    draw_graphics();
}

fn clear_canvas() {
    unsafe {
        if let Some(ctx) = &CANVAS_CONTEXT {
            ctx.set_fill_style(&"#000000".into());
            ctx.fill_rect(0.0, 0.0, CANVAS_WIDTH, CANVAS_HEIGHT);
        }
    }
}

fn draw_graphics() {
    unsafe {
        if let Some(ctx) = &CANVAS_CONTEXT {
            clear_canvas();
            
            // Set drawing style
            ctx.set_stroke_style(&"#ffffff".into());
            ctx.set_line_cap("round");
            
            // Your graphics code here
            let (param1, param2, param3) = PARAMS;
            
            // Example: draw a circle
            ctx.begin_path();
            ctx.arc(CANVAS_WIDTH / 2.0, CANVAS_HEIGHT / 2.0, param3 as f64, 0.0, 2.0 * f64::consts::PI).unwrap();
            ctx.stroke();
        }
    }
}

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}
