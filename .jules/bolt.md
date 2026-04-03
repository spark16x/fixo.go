## 2024-05-24 - Three.js Bundle Size Optimization
**Learning:** Three.js is a massive library that can significantly bloat the initial bundle size of a Next.js application if imported synchronously, blocking the main thread during hydration.
**Action:** Always wrap components containing heavy 3D libraries like Three.js in `next/dynamic` with `{ ssr: false }` to defer loading and rendering until after the critical path, keeping the initial payload lightweight.
