#!/bin/bash

echo "Building native projects..."

# Create the WASM output directory if it doesn't exist
mkdir -p public/dist/wasm

# Build Macroquad projects
echo "Building Macroquad projects..."
cd src/native/macroquad
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Building Macroquad project: $dir"
        cd "$dir"
        if command -v wasm-pack >/dev/null 2>&1; then
            wasm-pack build --target web --out-dir ../../../../public/dist/wasm/"$dir"
            echo "✅ Built $dir successfully"
        elif [ -f ~/.cargo/bin/wasm-pack ]; then
            ~/.cargo/bin/wasm-pack build --target web --out-dir ../../../../public/dist/wasm/"$dir"
            echo "✅ Built $dir successfully"
        else
            echo "❌ wasm-pack not found, skipping $dir"
        fi
        cd ..
    fi
done
cd ../../..

# Build Raylib projects (optional)
echo "Building Raylib projects..."
cd src/native/raylib
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Building Raylib project: $dir"
        cd "$dir"
        if command -v emcc >/dev/null 2>&1; then
            # Compile C source to WASM using emcc directly
            emcc main.c -o "${dir%/}.js" \
                -s USE_GLFW=3 \
                -s ASYNCIFY \
                -s TOTAL_MEMORY=67108864 \
                -s FORCE_FILESYSTEM=1 \
                -s ASSERTIONS=1 \
                --shell-file ../../../assets/shell_minimal.html \
                -DPLATFORM_WEB \
                --preload-file . \
                -s EXPORTED_FUNCTIONS="['_main','_start_project','_stop_project','_update_params']" \
                -s EXPORTED_RUNTIME_METHODS="['ccall','cwrap']"
            
            mkdir -p ../../../../public/dist/wasm/"$dir"
            cp "${dir%/}.js" "${dir%/}.wasm" ../../../../public/dist/wasm/"$dir"/ 2>/dev/null
            echo "✅ Built $dir successfully"
        else
            echo "❌ emscripten not found, skipping $dir"
        fi
        cd ..
    fi
done
cd ../../..

echo "Native build process completed!"