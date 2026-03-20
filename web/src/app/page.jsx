"use client";

import { useEffect } from "react";
import { animate } from "animejs";
import Link from "next/link";
import smoothScroll from "../lib/smoothScroll";
import Hero3D from "../components/Hero3D";
import DispatchMap from "../components/DispatchMap";

export default function Home() {
  
  useEffect(() => {
    
    smoothScroll();
    
    const scrollHandler = () => {
      const scrolled =
        window.scrollY /
        (document.body.scrollHeight - window.innerHeight);
      
      const bar = document.querySelector(".scroll-progress");
      if (bar) bar.style.width = scrolled * 100 + "%";
    };
    
    window.addEventListener("scroll", scrollHandler);
    
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        
        animate(entry.target, {
          translateY: [60, 0],
          opacity: [0, 1],
          duration: 900,
          easing: "easeOutExpo",
        });
        
        observer.unobserve(entry.target);
      });
    });
    
    document.querySelectorAll(".reveal").forEach((el) => {
      observer.observe(el);
    });
    
    return () => {
      window.removeEventListener("scroll", scrollHandler);
      observer.disconnect();
    };
    
  }, []);
  
  return (
    <main className="site-shell">

      <div className="scroll-progress" />

      <header className="top-nav">
        <div className="brand">FIXO.GO</div>
        <div className="nav-actions">
          <a href="#waitlist" className="btn btn-secondary">Join</a>
          <Link href="/terms">Terms</Link>
        </div>
      </header>

      {/* HERO */}

      <section className="hero reveal">
        <Hero3D />

        <h1>Roadside help, reimagined.</h1>

        <p className="hero-subtitle">
          AI-powered dispatch connecting drivers with nearby mechanics instantly.
        </p>

        <div className="hero-cta">
          <a className="btn btn-primary">Get Early Access</a>
        </div>
      </section>

      {/* FEATURES */}

      <section className="section">
        <h2 className="reveal">Built for scale</h2>

        <div className="feature-grid">
          {["Dispatch", "Tracking", "Quotes", "Earnings"].map((f) => (
            <div key={f} className="feature-card glass reveal">
              {f}
            </div>
          ))}
        </div>
      </section>

      {/* AI DISPATCH */}

      <section className="section section-alt">
        <h2 className="reveal">AI Dispatch Engine</h2>

        <div className="glass reveal" style={{ padding: 40 }}>
          <DispatchMap />
        </div>
      </section>

      {/* CTA */}

      <section className="section">
        <h2 className="reveal">Never get stranded again</h2>

        <div className="hero-cta reveal">
          <button className="btn btn-primary">Join Waitlist</button>
        </div>
      </section>

    </main>
  );
}