import { defineConfig } from "astro/config";
import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";

import react from "@astrojs/react";

// https://astro.build/config
export default defineConfig({
  devToolbar: {
    enabled: false
  },
  site: "https://jessai.dev",
  integrations: [
    mdx({
      shikiConfig: {
        theme: 'github-dark'
      }
    }), 
    sitemap(), 
    react()
  ],
  vite: {
    build: {
      rollupOptions: {
        external: ['canvas', 'fs']
      }
    }
  },
  server: {
    headers: {
      'Cross-Origin-Embedder-Policy': 'require-corp',
      'Cross-Origin-Opener-Policy': 'same-origin'
    }
  }
});