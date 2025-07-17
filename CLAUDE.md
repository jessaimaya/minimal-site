# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Development server**: `npm run dev` or `npm start` (includes native project build)
- **Build**: `npm run build` (includes `astro check` for type checking and native projects)
- **Preview build**: `npm run preview`
- **Type checking**: `astro check` (included in build command)
- **Native projects build**: `./build-native.sh` (automatically runs with dev/build commands)

### Native Projects

The site includes interactive WASM-based graphics projects built with Rust and C++:

- **Rust projects**: Located in `src/native/macroquad/` using wasm-pack for compilation
- **C++ projects**: Located in `src/native/raylib/` using emscripten for compilation
- **Build output**: Compiled to `public/dist/wasm/[project-name]/`
- **Requirements**: 
  - `wasm-pack` for Rust projects
  - `emscripten` for C++ projects (optional, skips if not installed)

## Architecture Overview

This is an Astro-based personal portfolio website with TypeScript, React components, and content collections. The site is deployed to jessai.dev.

### Content Collections

The site uses Astro's content collections with three main types:

1. **Blog posts** (`src/content/blog/`): Standard blog with frontmatter schema including title, description, pubDate, updatedDate, and heroImage
2. **Case studies** (`src/content/studies/`): Portfolio case studies with custom frontmatter including title, position, description, task arrays, and client information with logos
3. **Projects** (`src/content/projects/`): Interactive graphics projects with controls, difficulty, and framework metadata

**Important**: The studies collection is used throughout the codebase but not currently defined in `src/content/config.ts`. When adding or modifying studies content, you may need to add the studies collection schema to the config.

### Key Integrations

- **React**: Used for interactive components (e.g., Gallery carousel component using react-simply-carousel)
- **MDX**: Supported for enhanced markdown content
- **RSS**: Auto-generated RSS feed
- **Sitemap**: Auto-generated sitemap

### File Structure

- `src/layouts/`: Page layouts (BlogPost.astro, Studies.astro)
- `src/components/`: Reusable Astro and React components including NativeCanvas.astro for WASM integration
- `src/pages/`: Route-based pages including dynamic routes for blog, studies, and projects
- `src/content/`: Content collections (blog, studies, projects)
- `src/native/`: Native project source code (Rust/C++) for WASM compilation
- `src/styles/`: Global CSS including reset, utilities (utopia.css), and main styles
- `public/img/`: Client logos and portfolio images
- `public/fonts/`: Custom fonts (FiraCode, OpenSans, Atkinson)
- `public/dist/wasm/`: Compiled WASM modules and JavaScript bindings

### TypeScript Configuration

Uses Astro's strictest TypeScript config with React JSX support. Strict null checks are enabled.

### Content Management

- Blog posts use standard markdown/MDX with date-based organization
- Case studies include structured client data with logo assets (both normal and inverted versions for hover states)
- Global site constants are defined in `src/consts.ts`