## 2025-04-03 - Added skip-to-content link for keyboard accessibility
**Learning:** Next.js layout structures often lack built-in a11y mechanisms for keyboard navigation to bypass repeating layout elements. Screen reader and keyboard users can get stuck traversing common elements.
**Action:** Implement a reusable, visually-hidden (until focused) skip link pattern in the root `layout.js` that points to a consistent `#main-content` ID on page `<main>` tags.

## 2024-04-04 - Prevent focus loss on async buttons
**Learning:** Native `disabled` attributes remove elements from the tab order and immediately drop focus. For keyboard and screen reader users clicking a button with a loading state, this causes them to be abruptly thrown to the top of the document, losing their context.
**Action:** Use `aria-disabled="true"` combined with guarding the `onClick` handler for async button states, instead of the native `disabled` attribute. This keeps the button focusable while conveying its disabled state correctly.
