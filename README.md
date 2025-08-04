# Jessaí Maya - Personal Portfolio Website

A modern, interactive portfolio website built with Astro, featuring WASM-powered graphics projects, case studies, and a blog. The site showcases fullstack development work and includes interactive demos built with Rust and C++.

🌐 **Live Site**: [jessai.dev](https://jessai.dev)

## ✨ Features

- **Interactive Graphics Projects**: WASM-powered demos built with Rust (Macroquad) and C++ (Raylib)
- **Portfolio Case Studies**: Detailed project breakdowns with client work and technical implementations
- **Blog**: Technical articles and development insights
- **Responsive Design**: Mobile-first approach with modern CSS
- **Performance Optimized**: Fast loading with Astro's static site generation
- **SEO Ready**: Automatic sitemap and RSS feed generation

## 🚀 Tech Stack

- **Framework**: [Astro](https://astro.build/) with TypeScript
- **UI Components**: React for interactive elements
- **Content**: MDX for enhanced markdown content
- **Graphics**: Rust (Macroquad) and C++ (Raylib) compiled to WASM
- **Styling**: Modern CSS with custom properties and utilities
- **Build Tools**: Vite, wasm-pack, Emscripten

## 🛠️ Development

### Prerequisites

- Node.js (latest LTS recommended)
- Rust and Cargo (for WASM projects)
- `wasm-pack` (install via `npm run setup:tools`)
- Emscripten (optional, for C++ projects - install via `npm run setup:tools`)

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd minimal-site

# Install dependencies
npm install

# Install build tools (optional)
npm run setup:tools

# Start development server
npm run dev
```

Visit `http://localhost:4321` to see the site.

### Available Scripts

```bash
npm run dev          # Start development server (includes native builds)
npm run build        # Build for production (includes type checking)
npm run preview      # Preview production build
npm run build:native # Build all native WASM projects
npm run setup:tools  # Install wasm-pack and emscripten
```

## 📁 Project Structure

```
src/
├── components/          # Reusable Astro and React components
├── content/            # Content collections
│   ├── blog/          # Blog posts
│   ├── projects/      # Interactive project descriptions
│   └── studies/       # Portfolio case studies
├── layouts/           # Page layouts
├── native/            # WASM source code
│   ├── macroquad/     # Rust projects using Macroquad
│   └── raylib/        # C++ projects using Raylib
├── pages/             # Route-based pages
└── styles/            # Global CSS and utilities

public/
├── dist/wasm/         # Compiled WASM modules
├── fonts/             # Custom fonts (FiraCode, OpenSans, Atkinson)
└── img/               # Client logos and portfolio images
```

## 🎮 Interactive Projects

The site features interactive graphics demonstrations compiled to WebAssembly:

### Rust Projects (Macroquad)
- **Fractal Trees**: Recursive tree generation with L-systems
- **Starfield**: 3D starfield simulation with particle effects

### C++ Projects (Raylib)
- **Mandelbrot Set**: Real-time fractal visualization

Each project includes:
- Interactive controls for real-time parameter adjustment
- Educational explanations of algorithms and math
- Source code links and implementation details

## 📝 Content Management

### Blog Posts
Located in `src/content/blog/` with frontmatter schema:
```yaml
title: "Post Title"
description: "Post description"
pubDate: 2024-01-01
heroImage: "/blog-placeholder.jpg"
```

### Case Studies
Located in `src/content/studies/` with detailed project information:
```yaml
title: "Project Name"
position: "Role"
description: "Project description"
task: 
  - "Task 1"
  - "Task 2"
```

### Interactive Projects
Located in `src/content/projects/` with control definitions:
```yaml
title: "Project Name"
framework: "macroquad"
difficulty: "beginner"
controls:
  - name: "parameter"
    type: "range"
    min: 1
    max: 10
```

## 🌐 Deployment

The site is optimized for static hosting and automatically generates:
- Sitemap (`sitemap-index.xml`)
- RSS feed (`rss.xml`)
- Optimized assets and WASM bundles

Built files are output to `dist/` and ready for deployment to any static hosting provider.

## 🔧 Configuration

- **Astro Config**: `astro.config.mjs` - Main configuration
- **TypeScript**: Strict mode enabled with React JSX support
- **WASM Headers**: CORS headers configured for WASM loading
- **Site Constants**: Global values in `src/consts.ts`

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

Built with ❤️ by [Jessaí Maya](https://jessai.dev)