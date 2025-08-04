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

### C++ (Raylib)
- **Location**: `src/native/raylib/[project-name]/`
- **Compiler**: emscripten
- **API**: Raylib graphics library

### TypeScript (Three.js)
- **Location**: `src/native/threejs/[project-name]/`
- **Compiler**: TypeScript/Vite
- **API**: Three.js WebGL library

## Creating a New Project

### 1. Choose Framework and Project Name

```bash
# Example: Rust project called "spiral-galaxy"
FRAMEWORK="macroquad"  # or "raylib" or "threejs"
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

### 3B. C++ Project Setup (Raylib)

```bash
# Create main.cpp
cat > main.cpp << 'EOF'
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

extern "C" {
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
}

int main() {
    start_project();
    return 0;
}
EOF

# Replace PROJECT_NAME placeholder
sed -i "s/PROJECT_NAME/${PROJECT_NAME}/g" main.cpp
```

### 3C. TypeScript Project Setup (Three.js)

```bash
# Create package.json
cat > package.json << EOF
{
  "name": "${PROJECT_NAME}",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "three": "^0.160.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "vite": "^5.0.0",
    "@types/three": "^0.160.0"
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
EOF

# Create vite.config.ts
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    outDir: '../../../../public/dist/wasm/${PROJECT_NAME}',
    emptyOutDir: true,
    lib: {
      entry: 'src/main.ts',
      name: '${PROJECT_NAME//-/_}',
      fileName: 'main',
      formats: ['iife']
    }
  }
})
EOF

# Create src/main.ts with template
mkdir src
cat > src/main.ts << 'EOF'
import * as THREE from 'three';

// Global state
let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let renderer: THREE.WebGLRenderer;
let animationId: number | null = null;

// Parameters
let params = {
    param1: 5,
    param2: 25,
    param3: 100
};

export function init_PROJECT_NAME(canvasId: string): void {
    const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
    if (!canvas) {
        console.error('Canvas not found:', canvasId);
        return;
    }

    // Setup scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x000000);

    // Setup camera
    const aspect = canvas.width / canvas.height;
    camera = new THREE.PerspectiveCamera(75, aspect, 0.1, 1000);
    camera.position.z = 5;

    // Setup renderer
    renderer = new THREE.WebGLRenderer({ canvas });
    renderer.setSize(canvas.width, canvas.height);
}

export function start_PROJECT_NAME(): void {
    if (animationId !== null) return;
    
    const animate = () => {
        animationId = requestAnimationFrame(animate);
        render();
    };
    
    animate();
}

export function stop_PROJECT_NAME(): void {
    if (animationId !== null) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }
}

export function update_PROJECT_NAME_params(param1: number, param2: number, param3: number): void {
    params.param1 = Math.max(1, Math.min(20, param1));
    params.param2 = Math.max(0, Math.min(100, param2));
    params.param3 = Math.max(10, Math.min(500, param3));
    
    updateGraphics();
}

function updateGraphics(): void {
    // Clear existing objects
    while (scene.children.length > 0) {
        scene.remove(scene.children[0]);
    }

    // Add your graphics here
    const geometry = new THREE.SphereGeometry(params.param3 / 100);
    const material = new THREE.MeshBasicMaterial({ color: 0xffffff, wireframe: true });
    const sphere = new THREE.Mesh(geometry, material);
    scene.add(sphere);
}

function render(): void {
    if (renderer && scene && camera) {
        renderer.render(scene, camera);
    }
}

// Initialize graphics on first call
updateGraphics();
EOF

# Replace PROJECT_NAME placeholders
sed -i "s/PROJECT_NAME/${PROJECT_NAME//-/_}/g" src/main.ts
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

### C++ Projects
Your `main.cpp` must export these functions:
- `start_project()`
- `stop_project()`
- `update_params(param1, param2, ...)`

### TypeScript Projects
Your `main.ts` must export these functions:
- `init_[project_name](canvasId: string)`
- `start_[project_name]()`
- `stop_[project_name]()`
- `update_[project_name]_params(param1: number, param2: number, ...)`

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

### For C++ Projects  
- Install emscripten: Follow [emscripten installation guide](https://emscripten.org/docs/getting_started/downloads.html)

### For TypeScript Projects
- Node.js and npm (included in main project)
- Three.js will be installed per-project via npm

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

- Automatically reads the source file (lib.rs for Rust, main.cpp for C++)
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