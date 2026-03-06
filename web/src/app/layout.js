import "./globals.css";

export const metadata = {
  title: "FIXO.GO — Instant Roadside Assistance",
  description:
    "FIXO.GO connects drivers to nearby mechanics instantly with SOS dispatch, quotes, and live tracking.",
  openGraph: {
    title: "FIXO.GO",
    description: "One-tap roadside help with live mechanic tracking.",
    type: "website",
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "MobileApplication",
              name: "FIXO.GO",
              applicationCategory: "UtilitiesApplication",
              operatingSystem: "Android",
              description:
                "Emergency roadside assistance marketplace connecting users to nearby mechanics.",
            }),
          }}
        />
      </body>
    </html>
  );
}
