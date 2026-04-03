"use client";

import { useEffect } from "react";
import { animate } from "animejs";
import LiquidMetal from "../components/LiquidMetal";
import smoothScroll from "../lib/smoothScroll";

export default function Home() {
  
  useEffect(() => {
    
    const destroyScroll = smoothScroll();
    
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        
        animate(entry.target, {
          translateY: [80, 0],
          opacity: [0, 1],
          duration: 1000,
          easing: "easeOutExpo"
        });
        
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
<button className="btn primary">Join Waitlist</button>
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

<button className="btn primary reveal">
Get Early Access
</button>

</section>

</main>
    
  )
}