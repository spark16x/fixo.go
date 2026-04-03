## 2024-04-03 - Respect prefers-reduced-motion system setting
**Learning:** Heavy use of fluid WebGL animations and smooth scrolling can trigger motion sickness in users with vestibular disorders.
**Action:** Always check `window.matchMedia('(prefers-reduced-motion: reduce)')` to gracefully disable continuous animations, smooth scroll, and dramatic scroll reveals.
