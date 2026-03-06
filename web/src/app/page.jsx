"use client";

import Link from "next/link";
import { motion } from "framer-motion";

const features = [
  {
    title: "Smart Dispatch",
    description: "Requests are matched to nearby verified mechanics to reduce wait time.",
    icon: "🧭",
  },
  {
    title: "Live Tracking",
    description: "Track mechanic movement, ETA, and status updates in real time.",
    icon: "📍",
  },
  {
    title: "Transparent Quotes",
    description: "Receive multiple quotes and select the best price with confidence.",
    icon: "💬",
  },
  {
    title: "Mechanic Earnings",
    description: "Mechanics manage jobs, availability, and earnings from one dashboard.",
    icon: "🛠️",
  },
];

const steps = [
  "Choose service type and share pickup location.",
  "Nearby mechanics receive request and send quotes.",
  "Pick your mechanic, track arrival, and complete service.",
];

export default function Home() {
  return (
    <main className="site-shell">
      <header className="top-nav">
        <div className="brand">FIXO.GO</div>
        <div className="nav-actions">
          <a href="#waitlist" className="btn btn-secondary">
            Join waitlist
          </a>
          <Link href="/terms" className="btn btn-ghost">Terms</Link>
          <Link href="/privacy" className="btn btn-ghost">Privacy</Link>
          <a href="#partners" className="btn btn-primary">
            Become partner
          </a>
        </div>
      </header>

      <motion.section
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.55 }}
        className="hero"
      >
        <p className="eyebrow">Roadside assistance marketplace</p>
        <h1>Get roadside help in minutes, not hours.</h1>
        <p className="hero-subtitle">
          FIXO.GO connects drivers with nearby mechanics for puncture, towing, battery, fuel, and emergency
          repairs with real-time tracking and transparent pricing.
        </p>

        <div className="hero-cta">
          <a href="#waitlist" className="btn btn-primary">
            Request early access
          </a>
          <a href="#how-it-works" className="btn btn-secondary">
            See how it works
          </a>
        </div>

        <div className="hero-stats" aria-label="platform metrics">
          <Stat label="Response target" value="< 15 min" />
          <Stat label="Service types" value="5+" />
          <Stat label="Live tracking" value="24/7" />
        </div>
      </motion.section>

      <section className="section" id="features">
        <h2>Built for both drivers and mechanics</h2>
        <p className="section-subtitle">
          City-scale dispatch architecture with role-specific experiences for users and service partners.
        </p>
        <div className="feature-grid">
          {features.map((item) => (
            <article key={item.title} className="feature-card">
              <span className="feature-icon" aria-hidden>
                {item.icon}
              </span>
              <h3>{item.title}</h3>
              <p>{item.description}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="section section-alt" id="how-it-works">
        <h2>How FIXO.GO works</h2>
        <div className="step-grid">
          {steps.map((step, index) => (
            <div className="step" key={step}>
              <span className="step-index">0{index + 1}</span>
              <p>{step}</p>
            </div>
          ))}
        </div>
      </section>

      <section className="section" id="partners">
        <h2>Grow your mechanic business</h2>
        <p className="section-subtitle">
          Go online when you want, receive nearby jobs, submit quotes, and track monthly earnings.
        </p>
        <a href="#waitlist" className="btn btn-primary">
          Join as service partner
        </a>
      </section>

      <section className="section section-alt" id="waitlist">
        <h2>Get launch updates</h2>
        <p className="section-subtitle">Sign up for early access for users and mechanics.</p>
        <form className="waitlist-form" onSubmit={(event) => event.preventDefault()}>
          <input type="text" placeholder="Full name" required />
          <input type="email" placeholder="Email" required />
          <input type="text" placeholder="City" required />
          <button type="submit" className="btn btn-primary btn-block">
            Submit
          </button>
        </form>
      </section>

      <footer className="footer">
        <div>© {new Date().getFullYear()} FIXO.GO. All rights reserved.</div>
        <div className="footer-links">
          <Link href="/terms">Terms of Service</Link>
          <span>•</span>
          <Link href="/privacy">Privacy Policy</Link>
        </div>
      </footer>
    </main>
  );
}

function Stat({ label, value }) {
  return (
    <div className="stat-card">
      <span className="stat-value">{value}</span>
      <span className="stat-label">{label}</span>
    </div>
  );
}
