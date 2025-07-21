# Native Projects Setup Guide

This guide explains how to create new interactive graphics projects for the site.

## Project Structure

Each project consists of:

1. **Native source code** in `src/native/[framework]/[project-name]/`
2. **Content markdown** in `src/content/projects/[number]-[project-name].md`
3. **Automatic WASM compilation** to `public/dist/wasm/[project-name]/`

## Supported Frameworks

### Rust (Macroquad/Canvas 2D)
- **Location**: `src/native/macroquad/[project-name]/`
- **Compiler**: wasm-pack
- **API**: Canvas 2D via web-sys

### C (Raylib)
- **Location**: `src/native/raylib/[project-name]/`
- **Compiler**: emscripten
- **API**: Raylib graphics library

## Creating a New Project

### 1. Choose Framework and Project Name

```bash
# Example: Rust project called "spiral-galaxy"
FRAMEWORK="macroquad"  # or "raylib"
PROJECT_NAME="spiral-galaxy"
PROJECT_NUMBER="002"   # increment from last project
```

### 2. Create Project Directory

```bash
mkdir -p "src/native/${FRAMEWORK}/${PROJECT_NAME}"
cd "src/native/${FRAMEWORK}/${PROJECT_NAME}"
```

### 3A. Rust Project Setup

```bash
# Create Cargo.toml
cat > Cargo.toml << EOF
[package]
name = "${PROJECT_NAME}"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
wasm-bindgen = "0.2"
js-sys = "0.3"
web-sys = { version = "0.3", features = [
  "console",
  "CanvasRenderingContext2d",
  "Document",
  "Element",
  "HtmlCanvasElement",
  "Window",
] }
console_error_panic_hook = "0.1"
EOF

# Create src/lib.rs with template
mkdir src
cat > src/lib.rs << 'EOF'
use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};
use std::f64;

static mut PARAMS: (i32, f32, f32) = (5, 25.0, 100.0); // customize parameters
static mut CANVAS_CONTEXT: Option<CanvasRenderingContext2d> = None;
static mut CANVAS_WIDTH: f64 = 800.0;
static mut CANVAS_HEIGHT: f64 = 600.0;

#[wasm_bindgen]
pub fn init_PROJECT_NAME(canvas_id: &str) {
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
pub fn start_PROJECT_NAME() {
    draw_graphics();
}

#[wasm_bindgen]
pub fn stop_PROJECT_NAME() {
    clear_canvas();
}

#[wasm_bindgen]
pub fn update_PROJECT_NAME_params(param1: i32, param2: f32, param3: f32) {
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
EOF

# Replace PROJECT_NAME placeholders
sed -i "s/PROJECT_NAME/${PROJECT_NAME//-/_}/g" src/lib.rs
```

### 3B. C Project Setup (Raylib)

```bash
# Create main.c
cat > main.c << 'EOF'
#include "raylib.h"
#include <emscripten/emscripten.h>

const int screenWidth = 800;
const int screenHeight = 600;

// Parameters
static int param1 = 5;
static float param2 = 25.0f;
static float param3 = 100.0f;

void UpdateDrawFrame() {
    BeginDrawing();
    ClearBackground(BLACK);
    
    // Your graphics code here
    DrawCircle(screenWidth/2, screenHeight/2, param3, WHITE);
    
    EndDrawing();
}

void EMSCRIPTEN_KEEPALIVE start_project() {
    InitWindow(screenWidth, screenHeight, "PROJECT_NAME");
    emscripten_set_main_loop(UpdateDrawFrame, 60, 1);
}

void EMSCRIPTEN_KEEPALIVE stop_project() {
    emscripten_cancel_main_loop();
}

void EMSCRIPTEN_KEEPALIVE update_params(int p1, float p2, float p3) {
    param1 = p1;
    param2 = p2; 
    param3 = p3;
}

int main() {
    start_project();
    return 0;
}
EOF

# Replace PROJECT_NAME placeholder
sed -i "s/PROJECT_NAME/${PROJECT_NAME}/g" main.c

# Create a simple build script (optional - the main build uses emcc directly)
cat > build.sh << 'EOF'
#!/bin/bash
emcc main.c -o project.js \
    -s USE_GLFW=3 \
    -s ASYNCIFY \
    -s TOTAL_MEMORY=67108864 \
    -s FORCE_FILESYSTEM=1 \
    -s ASSERTIONS=1 \
    -DPLATFORM_WEB \
    -s EXPORTED_FUNCTIONS="['_main','_start_project','_stop_project','_update_params']" \
    -s EXPORTED_RUNTIME_METHODS="['ccall','cwrap']"
EOF
chmod +x build.sh
```

### 4. Create Content Markdown

```bash
cd ../../../..  # Back to project root
cat > "src/content/projects/${PROJECT_NUMBER}-${PROJECT_NAME}.md" << EOF
---
title: "Your Project Title"
description: "Brief description of what this project does"
date: $(date +%Y-%m-%d)
tags: ["graphics", "interactive", "wasm"]
difficulty: "beginner"  # or "intermediate" or "advanced"
framework: "${FRAMEWORK}"
projectName: "${PROJECT_NAME}"
originalSource: "https://example.com/original-source"  # optional
controls:
  - name: "param1"
    type: "range"
    min: 1
    max: 20
    step: 1
    default: 5
  - name: "param2"
    type: "range"
    min: 0
    max: 100
    step: 1
    default: 25
  - name: "param3"
    type: "range"
    min: 10
    max: 500
    step: 5
    default: 100
---

# Your Project Title

Detailed explanation of your project.

## How it works

1. Step one
2. Step two
3. Step three

## Controls

- **param1**: Description of parameter 1
- **param2**: Description of parameter 2
- **param3**: Description of parameter 3
EOF
```

### 5. Add Project to Page Template

Edit `src/pages/projects/[slug].astro` and add your project:

```astro
{project.slug === '${PROJECT_NUMBER}-${PROJECT_NAME}' && (
  <div style="margin: 2rem 0;">
    <NativeCanvas 
      project="${PROJECT_NAME}"
      framework="${FRAMEWORK}"
      width={800}
      height={600}
      controls={controls}
      sourceCode={sourceCode}
    />
  </div>
)}
```

### 6. Build and Test

```bash
# Build native projects
./build-native.sh

# Start development server
npm run dev

# Visit http://localhost:4322/projects/${PROJECT_NAME}
```

## Required Function Names

### Rust Projects
Your `lib.rs` must export these functions:
- `init_[project_name](canvas_id: &str)`
- `start_[project_name]()`
- `stop_[project_name]()`
- `update_[project_name]_params(param1: type, param2: type, ...)`

### C Projects
Your `main.c` must export these functions:
- `start_project()`
- `stop_project()`
- `update_params(param1, param2, ...)`

## Control Types

Available control types in project frontmatter:

```yaml
controls:
  - name: "iterations"
    type: "range"        # Slider
    min: 1
    max: 10
    step: 1
    default: 5
  
  - name: "speed"
    type: "number"       # Number input
    min: 0.1
    max: 5.0
    step: 0.1
    default: 1.0
  
  - name: "color"
    type: "color"        # Color picker
    default: "#ffffff"
  
  - name: "enabled"
    type: "checkbox"     # Checkbox
    default: true
```

## Build Requirements

### For Rust Projects
- Install wasm-pack: `curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh`

### For C Projects  
- Install emscripten: Follow [emscripten installation guide](https://emscripten.org/docs/getting_started/downloads.html)

## Troubleshooting

### Common Issues

1. **WASM module not found**: Ensure `./build-native.sh` runs successfully
2. **Functions not available**: Check function names match the pattern above
3. **Controls not working**: Verify control names match parameter names in your code
4. **Canvas not rendering**: Check browser console for errors

### Debug Steps

1. Check build output in `public/dist/wasm/[project-name]/`
2. Verify JavaScript bindings are generated
3. Test WASM module loads without errors
4. Confirm canvas element exists and has correct ID

## Code Visualizer Feature

The NativeCanvas component includes a "Show Code" button that displays the source code in a modal. This feature:

- Automatically reads the source file (lib.rs for Rust, main.c for C)
- Displays syntax-highlighted code in a modal overlay
- Provides easy access for users to understand implementation
- Maintains the minimal design aesthetic with monospace fonts

The code is passed via the `sourceCode` prop and only shows the button if source code is available.

## Tips

- Start with the fractal trees project as a reference
- Keep parameter validation (clamp values) in your native code
- Use appropriate Canvas 2D or Raylib APIs for your graphics
- Test controls work before adding complex graphics logic
- Follow the existing minimal design aesthetic
- The "Show Code" button appears automatically if source code is readable
- **Use safe Rust patterns**: Projects now use `thread_local!` with `RefCell` instead of `unsafe` blocks for better memory safety