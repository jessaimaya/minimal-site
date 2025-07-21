#!/bin/bash

# Automated Native Project Generator
# Usage: ./create-native-project.sh <framework> <project-name> [project-title] [description] [difficulty]
# Example: ./create-native-project.sh macroquad particle-system "Particle System" "Interactive particle physics simulation" intermediate

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function to print colored output
print_status() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Usage function
usage() {
    echo "Usage: $0 <framework> <project-name> [project-title] [description] [difficulty]"
    echo ""
    echo "Arguments:"
    echo "  framework      'macroquad' or 'raylib'"
    echo "  project-name   kebab-case name (e.g. 'particle-system')"
    echo "  project-title  Display name (e.g. 'Particle System') [optional]"
    echo "  description    Brief description [optional]"
    echo "  difficulty     'beginner', 'intermediate', or 'advanced' [optional, default: beginner]"
    echo ""
    echo "Examples:"
    echo "  $0 macroquad particle-system"
    echo "  $0 macroquad particle-system \"Particle System\" \"Interactive physics simulation\""
    echo "  $0 raylib snake-game \"Snake Game\" \"Classic snake game\" intermediate"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    print_error "Missing required arguments"
    usage
fi

# Parse arguments
FRAMEWORK="$1"
PROJECT_NAME="$2"
PROJECT_TITLE="${3:-$(echo "$PROJECT_NAME" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')}"
PROJECT_DESC="${4:-A $FRAMEWORK graphics project}"
DIFFICULTY="${5:-beginner}"

# Validate framework
if [[ ! "$FRAMEWORK" =~ ^(macroquad|raylib)$ ]]; then
    print_error "Framework must be 'macroquad' or 'raylib'"
    usage
fi

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    print_error "Project name must be lowercase with hyphens only (e.g. 'particle-system')"
    usage
fi

# Validate difficulty
if [[ ! "$DIFFICULTY" =~ ^(beginner|intermediate|advanced)$ ]]; then
    print_error "Difficulty must be 'beginner', 'intermediate', or 'advanced'"
    usage
fi

# Find next project number
print_status "Finding next project number..."
LAST_NUMBER=$(ls src/content/projects/ 2>/dev/null | grep -o '^[0-9]\+' | sort -n | tail -1 || echo "000")
PROJECT_NUMBER=$(printf "%03d" $((10#$LAST_NUMBER + 1)))

print_status "Creating project:"
echo "  Name: $PROJECT_NAME"
echo "  Title: $PROJECT_TITLE"
echo "  Framework: $FRAMEWORK"
echo "  Number: $PROJECT_NUMBER"
echo "  Difficulty: $DIFFICULTY"
echo "  Description: $PROJECT_DESC"
echo ""

# Create project directory
print_status "Creating project directory..."
PROJECT_DIR="src/native/$FRAMEWORK/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"

# Convert project name for function names (replace hyphens with underscores)
FUNC_NAME="${PROJECT_NAME//-/_}"

if [[ "$FRAMEWORK" == "macroquad" ]]; then
    print_status "Creating Rust macroquad project..."
    
    # Create Cargo.toml
    cat > "$PROJECT_DIR/Cargo.toml" << EOF
[package]
name = "$PROJECT_NAME"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

# For native development
[[bin]]
name = "main"
path = "src/main.rs"

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

[dependencies.macroquad]
version = "0.4"
optional = true

[features]
default = ["native"]
native = ["macroquad"]
EOF

    # Create src directory
    mkdir -p "$PROJECT_DIR/src"
    
    # Create lib.rs (WASM version)
    cat > "$PROJECT_DIR/src/lib.rs" << EOF
use wasm_bindgen::prelude::*;
use web_sys::{CanvasRenderingContext2d, HtmlCanvasElement};
use std::f64;

static mut PARAMS: (i32, f32, f32) = (5, 25.0, 100.0); // customize parameters
static mut CANVAS_CONTEXT: Option<CanvasRenderingContext2d> = None;
static mut CANVAS_WIDTH: f64 = 800.0;
static mut CANVAS_HEIGHT: f64 = 600.0;

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
    
    unsafe {
        CANVAS_CONTEXT = Some(context);
        CANVAS_WIDTH = canvas.width() as f64;
        CANVAS_HEIGHT = canvas.height() as f64;
    }
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
            
            // TODO: Add your graphics code here
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

    # Create main.rs (native version)
    cat > "$PROJECT_DIR/src/main.rs" << EOF
use macroquad::prelude::*;

// Parameters (same as WASM version)
static mut PARAMS: (i32, f32, f32) = (5, 25.0, 100.0);

#[macroquad::main("$PROJECT_TITLE")]
async fn main() {
    loop {
        clear_background(BLACK);
        
        // TODO: Add your graphics code here (same logic as draw_graphics in lib.rs)
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
EOF

elif [[ "$FRAMEWORK" == "raylib" ]]; then
    print_status "Creating C raylib project..."
    
    # Create main.c
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
    
    // TODO: Add your graphics code here
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

    # Create build script
    cat > "$PROJECT_DIR/build.sh" << 'EOF'
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
    chmod +x "$PROJECT_DIR/build.sh"
fi

# Create content markdown
print_status "Creating content markdown..."
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

# Add project to page template
print_status "Adding to page template..."
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
        print_success "Added to page template"
    else
        print_warning "Could not auto-add to page template. Please add manually."
    fi
else
    print_warning "Page template not found. Please add manually."
fi

print_success "Project '$PROJECT_NAME' created successfully!"
echo ""
echo -e "${BLUE}📁 Project structure:${NC}"
echo "  📂 $PROJECT_DIR/"
if [[ "$FRAMEWORK" == "macroquad" ]]; then
    echo "    📄 Cargo.toml"
    echo "    📂 src/"
    echo "      📄 lib.rs (WASM version)"
    echo "      📄 main.rs (native development)"
else
    echo "    📄 main.c"
    echo "    📄 build.sh"
fi
echo "  📄 $CONTENT_FILE"
echo ""
echo -e "${BLUE}🚀 Next steps:${NC}"
echo "1. Implement your graphics logic:"
if [[ "$FRAMEWORK" == "macroquad" ]]; then
    echo "   📝 Edit: $PROJECT_DIR/src/main.rs (native development)"
    echo "   📝 Copy logic to: $PROJECT_DIR/src/lib.rs (web version)"
    echo ""
    echo "2. Test locally (fast iteration):"
    echo "   cd $PROJECT_DIR && cargo run"
else
    echo "   📝 Edit: $PROJECT_DIR/main.c"
    echo ""
    echo "2. Test locally:"
    echo "   cd $PROJECT_DIR && ./build.sh"
fi
echo ""
echo "3. Update project description:"
echo "   📝 Edit: $CONTENT_FILE"
echo ""
echo "4. Build for web:"
echo "   ./build-native.sh"
echo "   npm run dev"
echo ""
echo "5. Visit: http://localhost:4322/projects/$PROJECT_NAME"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
if [[ "$FRAMEWORK" == "macroquad" ]]; then
    echo "- Use 'cargo run' for fast development iteration"
    echo "- Press 1/2/3 keys to test parameters in native version"
    echo "- Copy graphics logic from main.rs to lib.rs when ready for web"
else
    echo "- Use raylib documentation for graphics functions"
    echo "- Test with emscripten build before deploying"
fi
echo "- Update control descriptions in the markdown file"
echo "- Follow the existing minimal design aesthetic"