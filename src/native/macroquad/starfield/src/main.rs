use macroquad::prelude::*;

// Parameters (same as WASM version)
static mut PARAMS: (i32, f32, f32) = (5, 25.0, 100.0);

#[macroquad::main("starfield")]
async fn main() {
    loop {
        clear_background(BLACK);
        
        // Your graphics code here (same logic as draw_graphics in lib.rs)
        unsafe {
            let (param1, param2, param3) = PARAMS;
            
            // Example: draw a circle
            draw_circle(screen_width() / 2.0, screen_height() / 2.0, param3, WHITE);
        }
        
        // Handle input for parameter changes
        if is_key_pressed(KeyCode::Key1) {
            unsafe { PARAMS.0 = (PARAMS.0 % 20) + 1; }
        }
        if is_key_pressed(KeyCode::Key2) {
            unsafe { PARAMS.1 = (PARAMS.1 + 5.0) % 100.0; }
        }
        if is_key_pressed(KeyCode::Key3) {
            unsafe { PARAMS.2 = (PARAMS.2 + 10.0) % 500.0 + 10.0; }
        }
        
        // Display controls
        draw_text("Press 1/2/3 to change parameters", 10.0, 20.0, 20.0, WHITE);
        draw_text(&format!("Param1: {} (Press 1)", unsafe { PARAMS.0 }), 10.0, 40.0, 20.0, WHITE);
        draw_text(&format!("Param2: {:.1} (Press 2)", unsafe { PARAMS.1 }), 10.0, 60.0, 20.0, WHITE);
        draw_text(&format!("Param3: {:.1} (Press 3)", unsafe { PARAMS.2 }), 10.0, 80.0, 20.0, WHITE);
        
        next_frame().await
    }
}