"use client";

import { useEffect } from "react";
import { animate } from "animatejs";
import Link from "next/link";
import smoothScroll from "../lib/smoothScroll";

const features = [
{
  title: "Smart Dispatch",
  description: "Requests instantly route to the nearest verified mechanics.",
  icon: "🧭"
},
{
  title: "Live Tracking",
  description: "Track mechanic arrival with real-time GPS updates.",
  icon: "📍"
},
{
  title: "Transparent Quotes",
  description: "Compare prices from nearby mechanics before accepting.",
  icon: "💬"
},
{
  title: "Mechanic Earnings",
  description: "Mechanics manage jobs, quotes and monthly income.",
  icon: "🛠️"
}]

const steps = [
  "Choose your service and share your location.",
  "Nearby mechanics receive your request instantly.",
  "Select a quote and track mechanic arrival."
]

export default function Home() {
  
  useEffect(() => {
    
    smoothScroll()
    
    /* SCROLL PROGRESS */
    
    window.addEventListener("scroll", () => {
      const scrolled = window.scrollY /
        (document.body.scrollHeight - window.innerHeight)
      
      document.querySelector(".scroll-progress").style.width = scrolled * 100 + "%"
    })
    
    /* SCROLL REVEAL */
    
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        
        if (!entry.isIntersecting) return
        
        animate({
          targets: entry.target,
          translateY: [60, 0],
          opacity: [0, 1],
          duration: 900,
          easing: "easeOutExpo"
        })
        
        observer.unobserve(entry.target)
        
      })
    }, { threshold: .2 })
    
    document.querySelectorAll(".reveal").forEach(el => {
      observer.observe(el)
    })
    
    /* MAGNETIC BUTTON */
    
    document.querySelectorAll(".btn").forEach(btn => {
      
      btn.addEventListener("mousemove", (e) => {
        
        const rect = btn.getBoundingClientRect()
        
        const x = e.clientX - rect.left - rect.width / 2
        const y = e.clientY - rect.top - rect.height / 2
        
        animate({
          targets: btn,
          translateX: x * .2,
          translateY: y * .2,
          duration: 400,
          easing: "easeOutQuad"
        })
        
      })
      
      btn.addEventListener("mouseleave", () => {
        
        animate({
          targets: btn,
          translateX: 0,
          translateY: 0,
          duration: 400
        })
        
      })
      
    })
    
  }, [])
  
  return (
    
    <main className="site-shell">

<div className="scroll-progress"/>

<header className="top-nav">

<div className="brand">FIXO.GO</div>

<div className="nav-actions">

<a href="#waitlist" className="btn btn-secondary">
Join waitlist
</a>

<Link href="/terms" className="btn btn-ghost">
Terms
</Link>

<Link href="/privacy" className="btn btn-ghost">
Privacy
</Link>

<a href="#partners" className="btn btn-primary">
Become partner
</a>

</div>

</header>

{/* HERO */}

<section className="hero reveal">

<div className="particles">

{Array.from({length:20}).map((_,i)=>(
<span key={i}/>
))}

</div>

<p className="eyebrow">
Roadside assistance marketplace
</p>

<h1>
Get roadside help in minutes,
not hours.
</h1>

<p className="hero-subtitle">

FIXO.GO connects drivers with nearby mechanics
for puncture, towing, battery, fuel, and emergency repairs.

</p>

<div className="hero-cta">

<a href="#waitlist" className="btn btn-primary">
Request early access
</a>

<a href="#how-it-works" className="btn btn-secondary">
See how it works
</a>

</div>

<div className="hero-stats">

<Stat label="Response target" value="<15 min"/>
<Stat label="Service types" value="5+"/>
<Stat label="Live tracking" value="24/7"/>

</div>

</section>

{/* FEATURES */}

<section className="section">

<h2 className="reveal">
Built for drivers and mechanics
</h2>

<p className="section-subtitle reveal">
City-scale roadside dispatch platform
</p>

<div className="feature-grid">

{features.map(item=>(
<article key={item.title}
className="feature-card reveal">

<span className="feature-icon">
{item.icon}
</span>

<h3>{item.title}</h3>

<p>{item.description}</p>

</article>
))}

</div>

</section>

{/* HOW IT WORKS */}

<section id="how-it-works"
className="section section-alt">

<h2 className="reveal">
How FIXO.GO works
</h2>

<div className="step-grid">

{steps.map((step,index)=>(
<div key={step}
className="step reveal">

<span className="step-index">
0{index+1}
</span>

<p>{step}</p>

</div>
))}

</div>

</section>

{/* PARTNERS */}

<section id="partners"
className="section">

<h2 className="reveal">
Grow your mechanic business
</h2>

<p className="section-subtitle reveal">
Receive nearby jobs and manage your earnings.
</p>

<a href="#waitlist"
className="btn btn-primary reveal">
Join as service partner
</a>

</section>

{/* WAITLIST */}

<section id="waitlist"
className="section section-alt">

<h2 className="reveal">
Get launch updates
</h2>

<form className="waitlist-form reveal">

<input type="text"
placeholder="Full name"
required/>

<input type="email"
placeholder="Email"
required/>

<input type="text"
placeholder="City"
required/>

<button className="btn btn-primary btn-block">
Submit
</button>

</form>

</section>

<footer className="footer">

<div>
© {new Date().getFullYear()} FIXO.GO
</div>

</footer>

</main>
    
  )
}

function Stat({ label, value }) {
  
  return (
    
    <div className="stat-card reveal">

<span className="stat-value">
{value}
</span>

<span className="stat-label">
{label}
</span>

</div>
    
  )
}