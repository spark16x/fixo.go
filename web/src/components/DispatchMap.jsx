"use client";

import { useEffect, useRef } from "react";
import { animate } from "animejs";

export default function DispatchMap() {
  const ref = useRef(null);
  
  useEffect(() => {
    const dots = ref.current.querySelectorAll(".dot");
    
    dots.forEach((dot, i) => {
      animate(dot, {
        translateX: () => Math.random() * 200 - 100,
        translateY: () => Math.random() * 200 - 100,
        duration: 3000 + i * 200,
        direction: "alternate",
        loop: true,
        easing: "easeInOutSine",
      });
    });
  }, []);
  
  return (
    <div className="dispatch-map" ref={ref}>
      {Array.from({ length: 12 }).map((_, i) => (
        <span key={i} className="dot" />
      ))}
    </div>
  );
}