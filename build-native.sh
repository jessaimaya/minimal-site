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
        if command -v emcmake >/dev/null 2>&1; then
            emcmake cmake -B build -DCMAKE_BUILD_TYPE=Release
            emmake make -C build
            mkdir -p ../../../../public/dist/wasm/"$dir"
            cp build/*.js build/*.wasm ../../../../public/dist/wasm/"$dir"/ 2>/dev/null
            echo "✅ Built $dir successfully"
        else
            echo "❌ emscripten not found, skipping $dir"
        fi
        cd ..
    fi
done
cd ../../..

echo "Native build process completed!"