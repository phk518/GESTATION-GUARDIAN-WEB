# Gestation Guardian - Maternal RPM Dashboard

![Gestation Guardian UI](https://via.placeholder.com/1200x600/00497d/ffffff?text=Gestation+Guardian+Clinical+Dashboard)

**Gestation Guardian** is a clinical-grade Remote Patient Monitoring (RPM) web dashboard designed for obstetricians and maternity clinics. It provides real-time triage and monitoring of high-risk pregnancies through wearable sensor integration and a simulated RAG (Red/Amber/Green) scoring system.

## 🚀 Key Features

- **Live Telemetry Simulation:** Real-time scrolling smartwatch ECG and maternal heart rate charts.
- **RAG Triage Grid:** Patients are automatically grouped into **Critical (Red)**, **High Risk (Amber)**, and **Stable (Green)** statuses for rapid clinical assessment.
- **Deep-Dive Clinical Records:** Individual patient metric views for:
  - 1-Lead ECG
  - Blood Pressure
  - Fetal HR (HRV)
  - Blood Oxygen (SpO₂)
  - Respiratory Rate
- **Inter-Metric Navigation:** Sticky tab bars allowing doctors to switch between a patient's vitals seamlessly without losing patient context.
- **Dynamic Search & Filtering:** Instantly filter patients by status or search by name/ID, complete with zero-state handlers.

## 🛠️ Technology Stack

- **Frontend:** Vanilla HTML5, JavaScript, and Tailwind CSS (via CDN).
- **Design System:** Material Symbols, Glassmorphism aesthetic, Google Fonts (Inter & Manrope).
- **Charting:** Chart.js for real-time waveform rendering.
- **Testing:** Playwright (Chromium, Firefox, WebKit) for rigorous clinical protocol safety assertions.

## 🏃‍♂️ How to Run Locally

Because the dashboard uses modern ES6 modules and fetches shared components (like the sidebar) dynamically, it must be run on a local server.

### 1. Install Dependencies
Ensure you have [Node.js](https://nodejs.org/) installed, then run:
```bash
npm install
```

### 2. Start the Development Server
```bash
npx serve . -l 3000
```
Then open [http://localhost:3000](http://localhost:3000) in your browser.

## 🧪 Automated Testing

The project includes a robust Playwright E2E test suite ensuring clinical UI safety requirements are strictly met (Protocols 01-05).

To run the automated tests:
```bash
npx playwright test
```

To view the HTML report of the test results:
```bash
npx playwright show-report
```

## 📂 Project Structure

```text
├── components/          # Shared UI components (e.g., sidebar.html)
├── js/                  # Core application logic
│   ├── app.js           # Shared logic, navigation injection, live charts
│   └── dashboard.js     # Patient grid rendering and dynamic routing
├── pages/               # Deep-dive clinical metric pages
├── tests/               # Playwright testing suites
├── index.html           # Main dashboard entry point
└── playwright.config.ts # Playwright CI/CD configuration
```

## 🔒 Clinical Safety Notice

*This is a simulated dashboard meant for demonstration and UI/UX prototyping. It is not currently connected to real FDA-approved medical devices or live EHR systems. Simulated patient data is hardcoded for testing purposes.*
