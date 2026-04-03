"use client";

import Lenis from "lenis";

export default function smoothScroll() {
  
  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
  if (prefersReducedMotion.matches) return () => {};

  const lenis = new Lenis({
    duration: 1.2,
    smoothWheel: true,
    smoothTouch: false
  });
  
  let frameId;
  function raf(time) {
    lenis.raf(time)
    frameId = requestAnimationFrame(raf)
  }
  
  frameId = requestAnimationFrame(raf)

  // ⚡ Bolt: Return a cleanup function to prevent memory leaks and redundant animation frames when unmounted.
  return () => {
    cancelAnimationFrame(frameId);
    lenis.destroy();
  };
}