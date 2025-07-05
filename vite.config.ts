import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig } from "vite";
import postcssNesting from "postcss-nesting";

const __dirname = dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  base: "./", // https://vite.dev/guide/build.html#relative-base
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, "src/main.ts"),
        theme: resolve(__dirname, "src/theme.ts"),
        htmldiff_nav: resolve(__dirname, "src/htmldiff-nav.ts"),
      },
    },
    manifest: true, // https://vite.dev/guide/backend-integration.html
    sourcemap: true
  },
  css: {
    postcss: {
      plugins: [postcssNesting()]
    }
  }
});
