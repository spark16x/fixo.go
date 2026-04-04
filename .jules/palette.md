## 2024-04-03 - Button State Announcements
**Learning:** For simulated actions like joining a waitlist, updating button text ("Joining...", "Joined ✓") without explicit aria handling means screen readers might not announce the visual change immediately since the button has focus but the DOM changed silently for the user.
**Action:** Used `aria-live="polite"` on the button itself so screen readers announce the state transition smoothly without shifting focus away from the primary CTA.
