"use client";

import { useEffect, useRef } from "react";
import * as THREE from "three";

export default function LiquidMetal() {
  const ref = useRef();
  
  useEffect(() => {
    const scene = new THREE.Scene();
    
    const camera = new THREE.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      1000
    );
    
    const renderer = new THREE.WebGLRenderer({ alpha: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    ref.current.appendChild(renderer.domElement);
    
    const geometry = new THREE.PlaneGeometry(6, 6, 128, 128);
    
    const material = new THREE.ShaderMaterial({
      uniforms: { time: { value: 0 } },
      
      vertexShader: `
        uniform float time;
        varying vec2 vUv;

        void main() {
          vUv = uv;
          vec3 pos = position;

          pos.z += sin(pos.x * 3.0 + time) * 0.3;
          pos.z += cos(pos.y * 3.0 + time) * 0.3;

          gl_Position = projectionMatrix * modelViewMatrix * vec4(pos,1.0);
        }
      `,
      
      fragmentShader: `
        uniform float time;
        varying vec2 vUv;

        void main() {
          float wave = sin(vUv.x * 10.0 + time) * 0.5;

          vec3 color = vec3(
            0.2 + wave,
            0.3 + wave * 0.5,
            0.8
          );

          gl_FragColor = vec4(color,0.5);
        }
      `,
      transparent: true,
    });
    
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);
    
    camera.position.z = 3;
    
    const animate = () => {
      material.uniforms.time.value += 0.02;
      renderer.render(scene, camera);
      requestAnimationFrame(animate);
    };
    
    animate();
    
    return () => {
      renderer.dispose();
      ref.current.innerHTML = "";
    };
  }, []);
  
  return (
    <div
      ref={ref}
      style={{
        position: "absolute",
        inset: 0,
        zIndex: -1,
      }}
    />
  );
}