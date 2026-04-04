## 2024-05-24 - Three.js Bundle Size Optimization
**Learning:** Three.js is a massive library that can significantly bloat the initial bundle size of a Next.js application if imported synchronously, blocking the main thread during hydration.
**Action:** Always wrap components containing heavy 3D libraries like Three.js in `next/dynamic` with `{ ssr: false }` to defer loading and rendering until after the critical path, keeping the initial payload lightweight.

## 2024-05-24 - Three.js MSAA on Shader Quads
**Learning:** Using `antialias: true` on a Three.js WebGLRenderer creates a multisampled render buffer (MSAA), which consumes significant VRAM and GPU bandwidth. If the scene only contains a full-screen quad (like a custom shader background), there are no geometric edges to anti-alias, making MSAA entirely wasteful.
**Action:** Always set `antialias: false` when rendering full-screen shader quads or scenes where geometric edge smoothing is unnecessary.
