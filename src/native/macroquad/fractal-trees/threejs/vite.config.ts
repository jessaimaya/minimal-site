import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    outDir: '../../../../../public/dist/wasm/fractal-trees/threejs',
    emptyOutDir: true,
    lib: {
      entry: 'src/main.ts',
      name: 'fractal_trees_threejs',
      fileName: 'main',
      formats: ['iife']
    },
    rollupOptions: {
      output: {
        format: 'iife',
        name: 'fractal_trees_threejs',
        footer: 'window.fractal_trees_threejs = fractal_trees_threejs;'
      }
    }
  },
  define: {
    global: 'globalThis'
  }
})