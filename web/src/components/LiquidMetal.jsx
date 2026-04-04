"use client";

import { useEffect, useRef } from "react";
import * as THREE from "three";

export default function LiquidMetal() {
  const ref = useRef();
  
  useEffect(() => {
    const prefersReducedMotionLocal = window.matchMedia("(prefers-reduced-motion: reduce)");
    if (prefersReducedMotionLocal.matches) return;

    const scene = new THREE.Scene();
    
    const camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
    
    const renderer = new THREE.WebGLRenderer({
      antialias: true,
      powerPreference: "high-performance",
    });
    
    const mountRef = ref.current;
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    mountRef.appendChild(renderer.domElement);
    
    const uniforms = {
      u_time: { value: 0 },
      u_mouse: { value: new THREE.Vector2(0.5, 0.5) },
      u_resolution: {
        value: new THREE.Vector2(window.innerWidth, window.innerHeight),
      },
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

        // HASH
        float hash(vec2 p) {
          return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
        }

        // NOISE
        float noise(vec2 p){
          vec2 i = floor(p);
          vec2 f = fract(p);

          float a = hash(i);
          float b = hash(i + vec2(1.0,0.0));
          float c = hash(i + vec2(0.0,1.0));
          float d = hash(i + vec2(1.0,1.0));

          vec2 u = f*f*(3.0-2.0*f);

          return mix(a,b,u.x) +
                 (c-a)*u.y*(1.0-u.x) +
                 (d-b)*u.x*u.y;
        }

        // FBM (fluid layers)
        float fbm(vec2 p) {
          float v = 0.0;
          float a = 0.5;
          for (int i = 0; i < 5; i++) {
            v += a * noise(p);
            p *= 2.0;
            a *= 0.5;
          }
          return v;
        }

        void main() {
          vec2 uv = gl_FragCoord.xy / u_resolution.xy;

          // center UV
          vec2 p = uv * 2.0 - 1.0;
          p.x *= u_resolution.x / u_resolution.y;

          float t = u_time * 0.4;

          // mouse influence
          float dist = distance(uv, u_mouse);
          p += (u_mouse - 0.5) * 0.3;

          // fluid distortion
          float n = fbm(p * 3.0 + t);
          float n2 = fbm(p * 6.0 - t);

          float flow = n + n2;

          // metal waves
          float wave = sin(p.x * 8.0 + flow * 4.0 + t) +
                       cos(p.y * 8.0 + flow * 4.0);

          // color (metallic gradient)
          vec3 base = vec3(0.15, 0.2, 0.6);
          vec3 highlight = vec3(0.4, 0.5, 1.0);

          vec3 color = mix(base, highlight, wave * 0.5 + 0.5);

          // glow center
          float glow = smoothstep(0.5, 0.0, dist);
          color += glow * 0.6;

          // vignette
          float vignette = smoothstep(1.2, 0.2, length(p));
          color *= vignette;

          gl_FragColor = vec4(color, 1.0);
        }
      `,
    });
    
    const mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(2, 2),
      material
    );
    
    scene.add(mesh);
    
    const handleMouse = (e) => {
      uniforms.u_mouse.value.x = e.clientX / window.innerWidth;
      uniforms.u_mouse.value.y = 1 - e.clientY / window.innerHeight;
    };
    
    window.addEventListener("mousemove", handleMouse);
    
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    let frameId;
    const animate = () => {
      if (!prefersReducedMotion) {
        uniforms.u_time.value += 0.02;
      }
      renderer.render(scene, camera);
      frameId = requestAnimationFrame(animate);
    };
    
    animate();
    
    // cleanup
    return () => {
      window.removeEventListener("mousemove", handleMouse);
      // ⚡ Bolt: Prevent memory & CPU leaks by properly disposing Three.js resources and stopping the animation loop on unmount.
      cancelAnimationFrame(frameId);
      mesh.geometry.dispose();
      mesh.material.dispose();
      renderer.dispose();
      mountRef.innerHTML = "";
    };
  }, []);
  
  return (
    <div
      ref={ref}
      aria-hidden="true"
      style={{
        position: "fixed",
        inset: 0,
        zIndex: -1,
      }}
    />
  );
}