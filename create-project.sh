#!/bin/bash

# Interactive script to create a new native graphics project
# Usage: ./create-project.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎨 Native Project Generator${NC}"
echo "This script will create a new interactive graphics project."
echo

# Get project details from user
read -p "Project name (kebab-case, e.g., 'spiral-galaxy'): " PROJECT_NAME
if [[ ! $PROJECT_NAME =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}Error: Project name must be lowercase with hyphens only${NC}"
    exit 1
fi

read -p "Project title (display name, e.g., 'Spiral Galaxy'): " PROJECT_TITLE
if [[ -z "$PROJECT_TITLE" ]]; then
    echo -e "${RED}Error: Project title is required${NC}"
    exit 1
fi

echo "Select framework:"
echo "1) Rust (macroquad/Canvas 2D)"
echo "2) C (raylib)"
read -p "Choice (1 or 2): " FRAMEWORK_CHOICE

case $FRAMEWORK_CHOICE in
    1)
        FRAMEWORK="macroquad"
        ;;
    2)
        FRAMEWORK="raylib"
        ;;
    *)
        echo -e "${RED}Error: Invalid choice${NC}"
        exit 1
        ;;
esac

read -p "Project description: " PROJECT_DESC
read -p "Difficulty (beginner/intermediate/advanced): " DIFFICULTY

# Validate difficulty
if [[ ! "$DIFFICULTY" =~ ^(beginner|intermediate|advanced)$ ]]; then
    echo -e "${RED}Error: Difficulty must be beginner, intermediate, or advanced${NC}"
    exit 1
fi

# Find next project number
LAST_NUMBER=$(ls src/content/projects/ 2>/dev/null | grep -o '^[0-9]\+' | sort -n | tail -1 || echo "000")
PROJECT_NUMBER=$(printf "%03d" $((10#$LAST_NUMBER + 1)))

echo
echo -e "${YELLOW}Creating project:${NC}"
echo "  Name: $PROJECT_NAME"
echo "  Title: $PROJECT_TITLE"
echo "  Framework: $FRAMEWORK"
echo "  Number: $PROJECT_NUMBER"
echo "  Difficulty: $DIFFICULTY"
echo

read -p "Continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo
echo -e "${BLUE}🏗️  Creating project structure...${NC}"

# Create project directory
PROJECT_DIR="src/native/$FRAMEWORK/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"

# Convert project name for function names (replace hyphens with underscores)
FUNC_NAME="${PROJECT_NAME//-/_}"

if [[ "$FRAMEWORK" == "macroquad" ]]; then
    echo -e "${GREEN}📦 Creating Rust project...${NC}"
    
    # Create Cargo.toml
    cat > "$PROJECT_DIR/Cargo.toml" << EOF
[package]
name = "$PROJECT_NAME"
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

    # Create src directory and lib.rs
    mkdir -p "$PROJECT_DIR/src"
    cat > "$PROJECT_DIR/src/lib.rs" << EOF
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
pub fn init_${FUNC_NAME}(canvas_id: &str) {
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
pub fn start_${FUNC_NAME}() {
    draw_graphics();
}

#[wasm_bindgen]
pub fn stop_${FUNC_NAME}() {
    clear_canvas();
}

#[wasm_bindgen]
pub fn update_${FUNC_NAME}_params(param1: i32, param2: f32, param3: f32) {
    PARAMS.with(|params| {
        let mut p = params.borrow_mut();
        p.0 = param1.clamp(1, 20);
        p.1 = param2.clamp(0.0, 100.0);
        p.2 = param3.clamp(10.0, 500.0);
    });
    draw_graphics();
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

fn draw_graphics() {
    CANVAS_CONTEXT.with(|ctx_ref| {
        CANVAS_SIZE.with(|size_ref| {
            PARAMS.with(|params_ref| {
                if let Some(ctx) = ctx_ref.borrow().as_ref() {
                    let (width, height) = *size_ref.borrow();
                    let (param1, param2, param3) = *params_ref.borrow();
                    
                    clear_canvas();
                    
                    // Set drawing style
                    ctx.set_stroke_style(&"#ffffff".into());
                    ctx.set_line_cap("round");
                    
                    // TODO: Implement your graphics here
                    
                    // Example: draw a circle
                    ctx.begin_path();
                    ctx.arc(
                        width / 2.0, 
                        height / 2.0, 
                        param3 as f64, 
                        0.0, 
                        2.0 * f64::consts::PI
                    ).unwrap();
                    ctx.stroke();
                }
            });
        });
    });
}

#[wasm_bindgen(start)]
pub fn main() {
    console_error_panic_hook::set_once();
}
EOF

elif [[ "$FRAMEWORK" == "raylib" ]]; then
    echo -e "${GREEN}🎮 Creating C project...${NC}"
    
    cat > "$PROJECT_DIR/main.c" << EOF
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
    
    // TODO: Implement your graphics here
    DrawCircle(screenWidth/2, screenHeight/2, param3, WHITE);
    
    EndDrawing();
}

void EMSCRIPTEN_KEEPALIVE start_project() {
    InitWindow(screenWidth, screenHeight, "$PROJECT_TITLE");
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
fi

echo -e "${GREEN}📝 Creating content markdown...${NC}"

# Create content markdown
CONTENT_FILE="src/content/projects/${PROJECT_NUMBER}-${PROJECT_NAME}.md"
cat > "$CONTENT_FILE" << EOF
---
title: "$PROJECT_TITLE"
description: "$PROJECT_DESC"
date: $(date +%Y-%m-%d)
tags: ["graphics", "interactive", "wasm"]
difficulty: "$DIFFICULTY"
framework: "$FRAMEWORK"
projectName: "$PROJECT_NAME"
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

# $PROJECT_TITLE

$PROJECT_DESC

## How it works

1. TODO: Describe step one
2. TODO: Describe step two  
3. TODO: Describe step three

## Controls

- **param1**: TODO: Description of parameter 1
- **param2**: TODO: Description of parameter 2
- **param3**: TODO: Description of parameter 3

## Implementation Notes

TODO: Add implementation details, mathematical foundations, or other relevant information.
EOF

echo -e "${GREEN}🔧 Adding to page template...${NC}"

# Add project to page template
PAGE_TEMPLATE="src/pages/projects/[slug].astro"
if [[ -f "$PAGE_TEMPLATE" ]]; then
    # Find the insertion point (before the closing })
    INSERT_LINE=$(grep -n "^}" "$PAGE_TEMPLATE" | tail -1 | cut -d: -f1)
    if [[ -n "$INSERT_LINE" ]]; then
        # Create temporary file with the new content
        {
            head -n $((INSERT_LINE - 1)) "$PAGE_TEMPLATE"
            echo "    {project.slug === '${PROJECT_NUMBER}-${PROJECT_NAME}' && ("
            echo "      <div style=\"margin: 2rem 0;\">"
            echo "        <NativeCanvas "
            echo "          project=\"${PROJECT_NAME}\""
            echo "          framework=\"${FRAMEWORK}\""
            echo "          width={800}"
            echo "          height={600}"
            echo "          controls={controls}"
            echo "          sourceCode={sourceCode}"
            echo "        />"
            echo "      </div>"
            echo "    )}"
            echo ""
            tail -n +$INSERT_LINE "$PAGE_TEMPLATE"
        } > "${PAGE_TEMPLATE}.tmp"
        mv "${PAGE_TEMPLATE}.tmp" "$PAGE_TEMPLATE"
    else
        echo -e "${YELLOW}⚠️  Could not auto-add to page template. Please add manually.${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Page template not found. Please add manually.${NC}"
fi

echo
echo -e "${GREEN}✅ Project created successfully!${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Implement your graphics logic in:"
if [[ "$FRAMEWORK" == "macroquad" ]]; then
    echo "   ${PROJECT_DIR}/src/lib.rs (see draw_graphics function)"
else
    echo "   ${PROJECT_DIR}/main.c (see UpdateDrawFrame function)"
fi
echo "2. Update the control descriptions in:"
echo "   ${CONTENT_FILE}"
echo "3. Build and test:"
echo "   ./build-native.sh"
echo "   npm run dev"
echo "4. Visit: http://localhost:4322/projects/${PROJECT_NAME}"
echo
echo -e "${YELLOW}💡 Tips:${NC}"
echo "- Look at fractal-trees project for reference"
echo "- Update control min/max/step values to match your parameters"
echo "- Test controls work before implementing complex graphics"
echo "- Follow the minimal design aesthetic"
echo