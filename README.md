# Personal Website

A minimal, performance-focused portfolio website built with Astro, featuring interactive graphics projects and case studies. This site showcases my work in software engineering, graphics programming, and web development with a clean, monospace aesthetic.

## 🎯 Features

- **Interactive Graphics Projects**: WebAssembly-powered visualizations written in Rust and C
- **Case Studies**: Detailed project breakdowns with client work and technical implementations
- **Blog**: Technical writing and development insights
- **Minimal Design**: Clean, accessible interface with monospace typography
- **Performance First**: Static site generation with optimized assets and fast loading times
- **Native Development**: Local development workflow for graphics projects with web deployment

## 🛠 Tech Stack

- **Framework**: [Astro](https://astro.build/) - Static site generator with component islands
- **Styling**: CSS with custom properties and minimal design system
- **Graphics**: Rust (macroquad) + C (raylib) compiled to WebAssembly
- **Content**: Markdown with frontmatter for blog posts and project documentation
- **Typography**: FiraCode monospace with OpenSans and Atkinson fonts
- **Deployment**: Static hosting optimized for performance

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📁 Project Structure

```
├── src/
│   ├── components/          # Reusable Astro and React components
│   ├── content/            # Content collections
│   │   ├── blog/           # Blog posts
│   │   ├── projects/       # Interactive graphics projects
│   │   └── studies/        # Case studies
│   ├── layouts/            # Page layouts
│   ├── native/             # Native graphics projects
│   │   ├── macroquad/      # Rust projects
│   │   └── raylib/         # C projects
│   ├── pages/              # Route-based pages
│   └── styles/             # Global CSS and design system
├── public/                 # Static assets
│   ├── dist/wasm/         # Compiled WebAssembly modules
│   ├── fonts/             # Custom fonts
│   └── img/               # Images and logos
└── build-native.sh        # WASM build script
```

## Creating Native Graphics Projects

This site supports interactive graphics projects written in Rust (using macroquad) or C (using raylib) that compile to WebAssembly for web deployment.

### Quick Start

Use the automated project generator to create new projects:

```bash
# Basic usage
./create-native-project.sh <framework> <project-name>

# Full usage
./create-native-project.sh <framework> <project-name> [title] [description] [difficulty]
```

### Examples

**Rust/Macroquad Projects:**
```bash
# Minimal - auto-generates title and uses defaults
./create-native-project.sh macroquad particle-system

# With custom title and description
./create-native-project.sh macroquad spiral-galaxy "Galaxy Spiral" "Animated spiral galaxy simulation"

# Full specification
./create-native-project.sh macroquad mandelbrot-explorer "Mandelbrot Explorer" "Interactive fractal explorer with zoom" advanced
```

**C/Raylib Projects:**
```bash
# Game project
./create-native-project.sh raylib snake-game "Snake Game" "Classic snake game with modern graphics" beginner

# Graphics demo
./create-native-project.sh raylib ray-tracer "Ray Tracer" "Real-time ray tracing demo" advanced
```

### Development Workflow

The script creates both native and web versions of your project:

1. **Create Project:**
   ```bash
   ./create-native-project.sh macroquad your-project "Your Project" "Description" beginner
   ```

2. **Develop Locally (Fast Iteration):**
   ```bash
   cd src/native/macroquad/your-project
   cargo run  # For Rust projects
   # or
   cd src/native/raylib/your-project
   ./build.sh  # For C projects
   ```

3. **Deploy to Web:**
   ```bash
   ./build-native.sh  # Build WASM
   npm run dev        # Start dev server
   # Visit: http://localhost:4322/projects/your-project
   ```

### Arguments

- **framework** (required): `macroquad` or `raylib`
- **project-name** (required): kebab-case name (e.g., `particle-system`)
- **title** (optional): Display name (e.g., "Particle System")
- **description** (optional): Brief description
- **difficulty** (optional): `beginner`, `intermediate`, or `advanced` (default: `beginner`)

### What Gets Created

The script automatically:
- ✅ Creates project directory structure
- ✅ Generates Rust (`lib.rs` + `main.rs`) or C (`main.c`) templates
- ✅ Sets up proper build configuration
- ✅ Creates markdown content file with controls
- ✅ Updates page template to include your project
- ✅ Assigns next available project number

### Development Tips

**For Rust/Macroquad:**
- Use `cargo run` for fast local development with native graphics
- Press `1`/`2`/`3` keys to test parameter changes
- Copy graphics logic from `main.rs` to `lib.rs` when ready for web

**For C/Raylib:**
- Edit `main.c` with your graphics code
- Use raylib documentation for available functions
- Test with `./build.sh` before web deployment

**General:**
- Update control descriptions in the generated markdown file
- Follow the existing minimal design aesthetic
- The "Show Code" button appears automatically on the web version
