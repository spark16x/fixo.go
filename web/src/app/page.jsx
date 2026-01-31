"use client";
import { motion } from "framer-motion";

export default function Home() {
  return (
    <main>

      {/* NAV */}
      <nav className="flex justify-between items-center px-6 py-5 max-w-6xl mx-auto">
        <div className="text-xl font-bold tracking-wide">FIXO.GO</div>
        <button className="bg-blue-600 px-5 py-2 rounded-lg text-sm font-semibold">
          Early Access
        </button>
      </nav>

      {/* HERO */}
    <motion.section
      initial={{ opacity: 0, y: 40 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.7 }}
      className="text-center px-6 py-24 max-w-4xl mx-auto"
    >
  <h1 className="text-5xl md:text-6xl font-bold leading-tight mb-6">
    When your vehicle stops —
    <br /> help starts instantly.
   </h1>

  <p className="text-gray-400 text-lg mb-10">
    One-tap SOS roadside assistance with live mechanic tracking.
  </p>

  <div className="flex gap-4 justify-center">
    <button className="bg-red-600 px-7 py-4 rounded-xl font-semibold">
      Get Early Access
    </button>
    <button className="bg-zinc-800 px-7 py-4 rounded-xl border border-zinc-700">
      Join as Mechanic
    </button>
  </div>
</motion.section>

    {/* About mobile app */}
    <section className="px-6 py-24 max-w-6xl mx-auto grid md:grid-cols-2 gap-12 items-center">
  <div>
    <h2 className="text-4xl font-bold mb-6">
      Built for Real Road Emergencies
    </h2>

    <ul className="space-y-4 text-gray-400">
      <li>• One-tap SOS request</li>
      <li>• Real-time mechanic tracking</li>
      <li>• Car & bike support</li>
      <li>• OTP login only — no passwords</li>
      <li>• Dark-mode emergency UI</li>
    </ul>
  </div>

  <div className="bg-zinc-900 rounded-2xl p-10 border border-zinc-800 text-center">
    <div className="text-6xl mb-4">📱</div>
    <p className="text-gray-400">
      Android launch first. iOS next phase.
    </p>
  </div>
</section>

      {/* FEATURES */}
      <section className="grid md:grid-cols-3 gap-8 px-6 py-20 max-w-6xl mx-auto">
        {[
          ["🚨", "Instant SOS", "Tap once and request help"],
          ["📍", "Smart Matching", "Nearest mechanic auto-assigned"],
          ["🛰️", "Live Tracking", "Real-time ETA & movement"],
        ].map(([icon, title, text]) => (
          <div key={title} className="bg-zinc-900 p-8 rounded-2xl border border-zinc-800">
            <div className="text-3xl mb-4">{icon}</div>
            <h3 className="font-semibold mb-2">{title}</h3>
            <p className="text-gray-400 text-sm">{text}</p>
          </div>
        ))}
      </section>

      {/* HOW IT WORKS */}
      <section className="px-6 py-24 bg-zinc-950 text-center">
        <h2 className="text-4xl font-bold mb-14">How It Works</h2>

        <div className="grid md:grid-cols-3 gap-10 max-w-5xl mx-auto">
          <Step n="1" t="Tap SOS" d="Send instant breakdown alert" />
          <Step n="2" t="Get Matched" d="Nearby mechanic accepts" />
          <Step n="3" t="Track Arrival" d="Live map tracking" />
        </div>
      </section>

      {/* MECHANIC SECTION */}
      <section className="px-6 py-24 max-w-5xl mx-auto text-center">
        <h2 className="text-4xl font-bold mb-6">
          Built for Mechanics Too
        </h2>

        <p className="text-gray-400 mb-10">
          Get nearby jobs. Go online anytime. Grow your local income.
        </p>

        <button className="bg-blue-600 px-8 py-4 rounded-xl font-semibold">
          Become Service Partner
        </button>
      </section>

      {/* TRUST */}
      <section className="px-6 py-20 grid md:grid-cols-4 gap-6 max-w-6xl mx-auto text-center">
        {["OTP Login", "Verified Mechanics", "Live Location", "Privacy Safe"].map(x => (
          <div key={x} className="bg-zinc-900 p-6 rounded-xl border border-zinc-800 text-sm">
            {x}
          </div>
        ))}
      </section>

      {/* WAITLIST */}
      <section className="px-6 py-24 bg-zinc-950">
        <div className="max-w-xl mx-auto text-center">
          <h2 className="text-4xl font-bold mb-8">
            Join Early Access
          </h2>

          <form className="space-y-4">
            <Input placeholder="Name" />
            <Input placeholder="Phone" />
            <Input placeholder="City" />

            <button className="w-full bg-red-600 py-4 rounded-xl font-semibold">
              Join Waitlist
            </button>
          </form>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="text-center text-gray-500 py-12 text-sm">
        © {new Date().getFullYear()} FIXO.GO
      </footer>

    </main>
  );
}

function Step({ n, t, d }) {
  return (
    <div>
      <div className="text-blue-500 font-bold mb-3">Step {n}</div>
      <h3 className="font-semibold mb-2">{t}</h3>
      <p className="text-gray-400 text-sm">{d}</p>
    </div>
  );
}

function Input(props) {
  return (
    <input
      {...props}
      className="w-full p-4 rounded-xl bg-zinc-900 border border-zinc-800"
    />
  );
}