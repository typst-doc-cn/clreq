import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig } from "vite";

const __dirname = dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  base: "./", // https://vite.dev/guide/build.html#relative-base
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, "src/main.ts"),
      },
    },
    manifest: true, // https://vite.dev/guide/backend-integration.html
  },
});
