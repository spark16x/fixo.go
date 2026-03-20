"use client";

import { useEffect, useRef } from "react";
import * as THREE from "three";

export default function LiquidMetal() {
  const mountRef = useRef();
  
  useEffect(() => {
    const scene = new THREE.Scene();
    
    const camera = new THREE.OrthographicCamera(
      -1, 1, 1, -1, 0, 1
    );
    
    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    mountRef.current.appendChild(renderer.domElement);
    
    const uniforms = {
      u_time: { value: 0 },
      u_mouse: { value: new THREE.Vector2(0.5, 0.5) },
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight)
      }
    };
    
    const material = new THREE.ShaderMaterial({
      uniforms,
      
      vertexShader: `
        void main() {
          gl_Position = vec4(position, 1.0);
        }
      `,
      
      fragmentShader: `
        uniform float u_time;
        uniform vec2 u_mouse;
        uniform vec2 u_resolution;

        float noise(vec2 p){
          return sin(p.x)*sin(p.y);
        }

        void main() {
          vec2 uv = gl_FragCoord.xy / u_resolution;

          float t = u_time * 0.5;

          float n = noise(uv * 6.0 + t);

          float dist = distance(uv, u_mouse);

          float metal = sin(uv.x * 10.0 + n + t)
                      + cos(uv.y * 10.0 + n);

          vec3 color = vec3(
            0.2 + metal * 0.2,
            0.3 + metal * 0.3,
            0.8 + metal * 0.4
          );

          color *= 1.0 - dist;

          gl_FragColor = vec4(color, 1.0);
        }
      `,
    });
    
    const geometry = new THREE.PlaneGeometry(2, 2);
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);
    
    const onMouseMove = (e) => {
      uniforms.u_mouse.value.x = e.clientX / window.innerWidth;
      uniforms.u_mouse.value.y = 1 - e.clientY / window.innerHeight;
    };
    
    window.addEventListener("mousemove", onMouseMove);
    
    const animate = () => {
      uniforms.u_time.value += 0.03;
      renderer.render(scene, camera);
      requestAnimationFrame(animate);
    };
    
    animate();
    
    return () => {
      window.removeEventListener("mousemove", onMouseMove);
      renderer.dispose();
    };
    
  }, []);
  
  return (
    <div
      ref={mountRef}
      style={{
        position: "fixed",
        inset: 0,
        zIndex: -1
      }}
    />
  );
}