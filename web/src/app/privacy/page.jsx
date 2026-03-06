export const metadata = {
  title: 'Privacy Policy | FIXO.GO',
  description: 'Privacy Policy for FIXO.GO roadside assistance platform.',
};

export default function PrivacyPage() {
  return (
    <main className="legal-shell">
      <h1>Privacy Policy</h1>
      <p className="legal-updated">Last updated: 2026-03-06</p>

      <section>
        <h2>1. Information We Collect</h2>
        <ul>
          <li>Account details (name, email, role).</li>
          <li>Location data for request dispatch and live tracking.</li>
          <li>Service request and quote data.</li>
          <li>Device/app logs for reliability and fraud prevention.</li>
        </ul>
      </section>

      <section>
        <h2>2. How We Use Data</h2>
        <ul>
          <li>Match users with nearby mechanics.</li>
          <li>Enable service coordination and status updates.</li>
          <li>Improve product quality, safety, and support.</li>
        </ul>
      </section>

      <section>
        <h2>3. Data Sharing</h2>
        <p>
          We share necessary service details between users and mechanics to complete jobs. We may also share data with
          trusted infrastructure providers (e.g., cloud, messaging, analytics) under contractual safeguards.
        </p>
      </section>

      <section>
        <h2>4. Data Retention</h2>
        <p>
          We retain data for operational, legal, and safety purposes and delete or anonymize data when no longer
          needed.
        </p>
      </section>

      <section>
        <h2>5. Security</h2>
        <p>
          We use reasonable technical and organizational controls. However, no system is 100% secure, so users should
          also protect account credentials.
        </p>
      </section>

      <section>
        <h2>6. Your Choices</h2>
        <ul>
          <li>You can request account data updates or deletion, subject to legal requirements.</li>
          <li>You can disable location permissions, though core dispatch features may not work.</li>
        </ul>
      </section>

      <section>
        <h2>7. Contact</h2>
        <p>
          For privacy requests, contact{' '}
          <a href="mailto:privacy@fixo-go.com">privacy@fixo-go.com</a>.
        </p>
      </section>
    </main>
  );
}
