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
if [ -d "src/native/raylib" ]; then
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
else
    echo "❌ src/native/raylib directory not found, skipping Raylib projects"
fi

# Build Three.js projects (standalone)
echo "Building standalone Three.js projects..."
if [ -d "src/native/threejs" ]; then
    cd src/native/threejs
    for dir in */; do
        if [ -d "$dir" ]; then
            echo "Building Three.js project: $dir"
            cd "$dir"
            if [ -f "package.json" ]; then
                if command -v npm >/dev/null 2>&1; then
                    npm install
                    npm run build
                    echo "✅ Built $dir successfully"
                else
                    echo "❌ npm not found, skipping $dir"
                fi
            else
                echo "❌ package.json not found in $dir, skipping"
            fi
            cd ..
        fi
    done
    cd ../../..
fi

# Build embedded Three.js projects (in other framework directories)
echo "Building embedded Three.js projects..."
find src/native -name "threejs" -type d | while read threejs_dir; do
    if [ -f "$threejs_dir/package.json" ]; then
        echo "Building embedded Three.js project: $threejs_dir"
        original_dir=$(pwd)
        cd "$threejs_dir"
        if command -v npm >/dev/null 2>&1; then
            npm install > /dev/null 2>&1
            npm run build
            echo "✅ Built embedded Three.js project successfully"
        else
            echo "❌ npm not found, skipping embedded project"
        fi
        cd "$original_dir"
    fi
done

echo "Native build process completed!"