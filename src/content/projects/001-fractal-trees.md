---
title: "Fractal Trees"
description: "Recursive fractal tree generation implemented in multiple languages"
date: 2024-01-01
tags: ["fractals", "recursion", "graphics", "rust", "typescript", "threejs"]
difficulty: "beginner"
projectName: "fractal-trees"
originalSource: "https://thecodingtrain.com/challenges/14-fractal-trees-recursive"
frameworks:
  - name: "macroquad"
    displayName: "Rust + Canvas2D"
    # Source code is automatically loaded from src/native/macroquad/fractal-trees/src/lib.rs
  - name: "threejs"
    displayName: "TypeScript + Three.js"
    # Source code is automatically loaded from src/native/macroquad/fractal-trees/threejs/src/main.ts
controls:
  - name: "iterations"
    type: "range"
    min: 1
    max: 10
    step: 1
    default: 5
  - name: "angle"
    type: "range"
    min: 10
    max: 45
    step: 1
    default: 25
  - name: "length"
    type: "range"
    min: 50
    max: 150
    step: 5
    default: 100
---

# Fractal Trees

This project explores recursive fractal tree generation using L-systems, implemented in **multiple programming languages** to demonstrate how the same algorithm can be expressed differently while achieving the same visual result.

## Multiple Implementations

Use the tabs above to switch between different implementations:

- **Rust + Canvas2D**: Low-level implementation compiled to WebAssembly using Rust and Canvas 2D API
- **TypeScript + Three.js**: High-level implementation using Three.js WebGL library with gentle rotation animation

## How it works

1. **Base case**: When depth reaches 0, stop recursion
2. **Draw branch**: Draw a line from current position at given angle
3. **Recursive calls**: Create two new branches at +/- angle offsets
4. **Scaling**: Each level reduces branch length by ~25-33%

## Mathematical Foundation

The fractal tree uses simple trigonometry:
- `end_x = x + length * cos(angle)`
- `end_y = y + length * sin(angle)`

## Implementation Differences

### Rust + Canvas2D
- **Performance**: Compiled to WASM for near-native performance
- **Size**: Small bundle (~50KB)
- **Rendering**: Direct Canvas 2D API calls
- **Safety**: Memory-safe with Rust's ownership system

### TypeScript + Three.js
- **Development**: Easier to write and debug
- **Features**: Built-in rotation animation, WebGL acceleration
- **Size**: Larger bundle (~600KB with Three.js)
- **Flexibility**: Rich 3D graphics capabilities

## Controls

- **Iterations**: Controls the depth of recursion (tree complexity)
- **Angle**: The branching angle between left and right branches
- **Length**: The initial length of the trunk

## Original Source

Based on [The Coding Train's Fractal Trees Challenge](https://thecodingtrain.com/challenges/14-fractal-trees-recursive)