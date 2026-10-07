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
  markdown: {
    // Code follows the site's theme switch (styles in global.css)
    shikiConfig: {
      themes: { light: "github-light", dark: "github-dark" },
      defaultColor: false,
    },
  },
  redirects: {
    "/about": "/#about",
  },
  integrations: [
    mdx(),
    sitemap(),
    react(),
  ]
});