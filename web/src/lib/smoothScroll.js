"use client";

import Lenis from "lenis";

export default function smoothScroll() {
  
  const prefersReducedMotion = typeof window !== 'undefined' && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const lenis = new Lenis({
    duration: 1.2,
    smoothWheel: !prefersReducedMotion,
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