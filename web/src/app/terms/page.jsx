export const metadata = {
  title: 'Terms of Service | FIXO.GO',
  description: 'Terms of Service for FIXO.GO roadside assistance platform.',
};

export default function TermsPage() {
  return (
    <main className="legal-shell">
      <h1>Terms of Service</h1>
      <p className="legal-updated">Last updated: 2026-03-06</p>

      <section>
        <h2>1. Acceptance of Terms</h2>
        <p>
          By using FIXO.GO apps and website, you agree to these Terms of Service. If you do not agree, please do not
          use the platform.
        </p>
      </section>

      <section>
        <h2>2. Services</h2>
        <p>
          FIXO.GO is a marketplace connecting users needing roadside help with independent mechanics. Response times
          and service quality can vary based on location, traffic, mechanic availability, and external conditions.
        </p>
      </section>

      <section>
        <h2>3. User Responsibilities</h2>
        <ul>
          <li>Provide accurate location and contact details.</li>
          <li>Use the platform lawfully and respectfully.</li>
          <li>Pay agreed charges for completed services.</li>
        </ul>
      </section>

      <section>
        <h2>4. Mechanic Responsibilities</h2>
        <ul>
          <li>Provide accurate profile and service information.</li>
          <li>Offer truthful quotes and ETA estimates.</li>
          <li>Deliver services safely and professionally.</li>
        </ul>
      </section>

      <section>
        <h2>5. Payments and Quotes</h2>
        <p>
          Quotes are submitted by mechanics. Final pricing is based on the accepted quote and any mutually agreed
          adjustments due to actual job conditions.
        </p>
      </section>

      <section>
        <h2>6. Liability</h2>
        <p>
          FIXO.GO acts as a technology platform and is not a direct provider of roadside repair services. To the
          fullest extent allowed by law, FIXO.GO is not liable for indirect or consequential damages.
        </p>
      </section>

      <section>
        <h2>7. Account Suspension</h2>
        <p>
          Accounts may be suspended or terminated for fraud, abuse, policy violations, or behavior that risks platform
          safety.
        </p>
      </section>

      <section>
        <h2>8. Contact</h2>
        <p>
          For legal or support requests, contact us at{' '}
          <a href="mailto:support@fixo-go.com">support@fixo-go.com</a>.
        </p>
      </section>
    </main>
  );
}
