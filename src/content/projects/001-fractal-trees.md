---
title: "Fractal Trees"
description: "Recursive fractal tree generation using L-systems"
date: 2024-01-01
tags: ["fractals", "recursion", "graphics"]
difficulty: "beginner"
framework: "macroquad"
projectName: "fractal-trees"
originalSource: "https://thecodingtrain.com/challenges/14-fractal-trees-recursive"
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

This project explores recursive fractal tree generation using L-systems. The algorithm starts with a trunk and recursively generates branches at specified angles.

## How it works

1. **Base case**: When depth reaches 0, stop recursion
2. **Draw branch**: Draw a line from current position at given angle
3. **Recursive calls**: Create two new branches at +/- angle offsets
4. **Scaling**: Each level reduces branch length by ~30%

## Mathematical Foundation

The fractal tree uses simple trigonometry:
- `end_x = x + length * cos(angle)`
- `end_y = y + length * sin(angle)`

## Controls

- **Iterations**: Controls the depth of recursion (tree complexity)
- **Angle**: The branching angle between left and right branches
- **Length**: The initial length of the trunk

## Original Source

Based on [The Coding Train's Fractal Trees Challenge](https://thecodingtrain.com/challenges/14-fractal-trees-recursive)