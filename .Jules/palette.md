## 2025-04-03 - Added skip-to-content link for keyboard accessibility
**Learning:** Next.js layout structures often lack built-in a11y mechanisms for keyboard navigation to bypass repeating layout elements. Screen reader and keyboard users can get stuck traversing common elements.
**Action:** Implement a reusable, visually-hidden (until focused) skip link pattern in the root `layout.js` that points to a consistent `#main-content` ID on page `<main>` tags.
