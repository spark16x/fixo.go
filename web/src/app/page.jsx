"use client";

import { useEffect, useState } from "react";
import { animate } from "animejs";
import dynamic from "next/dynamic";
import smoothScroll from "../lib/smoothScroll";

// ⚡ Bolt: Dynamically import LiquidMetal (which loads Three.js) to reduce initial bundle size and speed up page load
const LiquidMetal = dynamic(() => import("../components/LiquidMetal"), { ssr: false });

export default function Home() {
  const [isJoining, setIsJoining] = useState(false);
  const [hasJoined, setHasJoined] = useState(false);

  const handleJoin = () => {
    setIsJoining(true);
    setTimeout(() => {
      setIsJoining(false);
      setHasJoined(true);
    }, 1500);
  };
  
  useEffect(() => {
    
    const destroyScroll = smoothScroll();
    
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        
        const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        if (prefersReducedMotion) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        } else {
          animate(entry.target, {
            translateY: [80, 0],
            opacity: [0, 1],
            duration: 1000,
            easing: "easeOutExpo"
          });
        }
        
        observer.unobserve(entry.target);
      });
    });
    
    document.querySelectorAll(".reveal").forEach(el => {
      observer.observe(el);
    });
    
    return () => {
      destroyScroll();
      observer.disconnect();
    };
  }, []);
  
  return (
    
    <main id="main-content">

{/* HERO */}

<section className="hero">

<LiquidMetal />

<div className="hero-content reveal">

<p className="tag">🚀 Next-gen roadside platform</p>

<h1>
Roadside assistance,<br/>
but actually instant.
</h1>

<p className="subtitle">
AI-powered dispatch connects you to nearby mechanics
within seconds — not hours.
</p>

<div className="cta">
<button
  className="btn primary"
  onClick={handleJoin}
  disabled={isJoining || hasJoined}
  aria-live="polite"
>
  {isJoining ? "Joining..." : hasJoined ? "Joined ✓" : "Join Waitlist"}
</button>
<button className="btn ghost">See Demo</button>
</div>

</div>

</section>

{/* FEATURES */}

<section className="section">

<h2 className="reveal">Built for speed & reliability</h2>

<div className="grid">

{["Instant Dispatch","Live Tracking","Transparent Pricing","Mechanic Growth"]
.map(f=>(
<div className="card glass reveal" key={f}>
<h3>{f}</h3>
<p>Optimized experience with real-time systems.</p>
</div>
))}

</div>

</section>

{/* AI SECTION */}

<section className="section alt">

<h2 className="reveal">AI dispatch engine</h2>

<p className="reveal">
Smart routing assigns best mechanic instantly.
</p>

</section>

{/* TRUST */}

<section className="section">

<h2 className="reveal">Why FIXO.GO</h2>

<div className="grid">

<div className="card glass reveal">⚡ Faster than competitors</div>
<div className="card glass reveal">📍 Real-time tracking</div>
<div className="card glass reveal">💰 Best pricing</div>

</div>

</section>

{/* CTA */}

<section className="section">

<h2 className="reveal">
Never get stranded again.
</h2>

<button
  className="btn primary reveal"
  onClick={handleJoin}
  disabled={isJoining || hasJoined}
  aria-live="polite"
>
  {isJoining ? "Joining..." : hasJoined ? "Joined ✓" : "Get Early Access"}
</button>

</section>

</main>
    
  )
}