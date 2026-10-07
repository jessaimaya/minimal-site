---
title: "Fractal trees"
description: "One recursive function, drawn twice: Rust compiled to WebAssembly on a 2D canvas, and TypeScript with Three.js."
date: 2025-08-03
experiment: "fractal-trees"
ramp: tide
runtimes:
  - type: wasm
    label: "Rust + WebAssembly"
    src: "/dist/wasm/fractal-trees/fractal_trees.js"
    source: "macroquad/fractal-trees/src/lib.rs"
  - type: script
    label: "Three.js"
    src: "/dist/wasm/fractal-trees/threejs/main.iife.js"
    global: "fractal_trees_threejs"
    source: "macroquad/fractal-trees/threejs/src/main.ts"
controls:
  - name: iterations
    label: "Depth"
    min: 1
    max: 13
    step: 1
    value: 10
  - name: angle
    label: "Angle"
    min: 5
    max: 60
    step: 1
    value: 25
  - name: length
    label: "Trunk"
    min: 60
    max: 180
    step: 5
    value: 140
credit:
  label: "The Coding Train, Coding Challenge #14"
  url: "https://thecodingtrain.com/challenges/14-fractal-trees-recursive"
---

A tree is a branch with two smaller trees growing out of its end. That sentence is the whole algorithm: draw a line, turn left and draw a shorter tree, turn right and draw another one, and stop when you run out of depth.

Each step only needs a bit of trigonometry to find where the branch ends:

```
end_x = x + length * cos(angle)
end_y = y + length * sin(angle)
```

Every child is three quarters the length of its parent, so the tree never grows past a fixed height no matter how deep it goes. Depth is the expensive part: each level doubles the number of branches, and at 13 the canvas is drawing more than eight thousand lines per frame.

## Two versions

The first one is Rust, compiled to WebAssembly, drawing straight onto a 2D canvas. The colour comes from how deep a branch is: the trunk starts blue and blends through steel and teal to seafoam tips, while every level sways a little out of step with the one below it.

The second one is the same recursion in TypeScript, handed to Three.js as line segments. The tree is still flat, but it lives in 3D space, so turning it around the trunk shows it for what it is: a thin sheet of lines that almost disappears when it faces sideways.

Both expose the same small set of functions to this page, `setup`, `frame`, `set_param` and `set_palette`, so the sliders above drive either one and both draw with the same colours.
