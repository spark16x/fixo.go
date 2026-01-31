import "./globals.css";
import { Inter, Space_Grotesk } from "next/font/google";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-body",
});

const grotesk = Space_Grotesk({
  subsets: ["latin"],
  variable: "--font-heading",
});

export const metadata = {
  title: "FIXO.GO — Instant Roadside Assistance App",
  description:
    "FIXO.GO connects drivers to nearby mechanics instantly with SOS and live tracking.",
  openGraph: {
    title: "FIXO.GO",
    description: "One-tap roadside help",
    type: "website",
  },
};


export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        <meta name="google-site-verification" content="7SnpTJD94MylkjVp3A2GY9wDF1Xhvs1yLkq_AH7nJxQ" />
      </head>
      <body className={`${inter.variable} ${grotesk.variable}`}>
        {children}
        <script
  type="application/ld+json"
  dangerouslySetInnerHTML={{
    __html: JSON.stringify({
      "@context": "https://schema.org",
      "@type": "MobileApplication",
      name: "FIXO.GO",
      applicationCategory: "TravelApplication",
      operatingSystem: "Android",
      description: "Emergency roadside assistance app",
    }),
  }}
/>

      </body>
    </html>
  );
}