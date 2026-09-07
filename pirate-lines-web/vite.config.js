import { defineConfig } from 'vite';

// GitHub Pages serves this project site under /Grid/, but the dev server runs
// at the root. Anything referencing /assets/ from JS must go through
// import.meta.env.BASE_URL, which Vite fills in from this value.
export default defineConfig(({ command }) => ({
  base: command === 'build' ? '/Grid/' : '/',
}));
