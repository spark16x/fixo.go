"use client";

import { Canvas, useFrame } from "@react-three/fiber";
import { MeshDistortMaterial, Sphere } from "@react-three/drei";
import { useRef } from "react";

function AnimatedSphere() {
  const ref = useRef();
  
  useFrame(({ mouse }) => {
    if (!ref.current) return;
    ref.current.rotation.y += 0.01;
    ref.current.rotation.x = mouse.y * 0.5;
    ref.current.rotation.y = mouse.x * 0.5;
  });
  
  return (
    <Sphere args={[1.5, 64, 64]} ref={ref}>
      <MeshDistortMaterial
        color="#4f46e5"
        distort={0.4}
        speed={2}
      />
    </Sphere>
  );
}

export default function Hero3D() {
  return (
    <Canvas
      style={{
        position: "absolute",
        inset: 0,
        zIndex: -1,
      }}
    >
      <ambientLight intensity={1.5} />
      <AnimatedSphere />
    </Canvas>
  );
}