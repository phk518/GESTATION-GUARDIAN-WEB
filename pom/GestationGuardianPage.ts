import { Page, Locator, expect } from '@playwright/test';
import { pathToFileURL } from 'url';

export class GestationGuardianPage {
  readonly page: Page;
  // Industrial Selectors
  readonly patientGrid: Locator;
  readonly patientRows: Locator;
  readonly criticalBadge: Locator;

  constructor(page: Page) {
    this.page = page;
    this.patientGrid = page.locator('main, section, #dashboard'); // Target the main container
    this.patientRows = page.locator('.patient-row, tr, [class*="patient"]');
    // Targeting the Critical Triage color: #ef4444 (Tailwind bg-red-500/600)
    this.criticalBadge = page.locator('[class*="bg-red"]'); 
  }

  async navigate() {
    const dashboardPath = 'C:/Users/PHK/Downloads/DOCTOR-RAGBOARD-WEB/stitch_doctor_dashboard_ui/pages/patient-detail.html'; // Re-using the discovered path
    const fileUrl = pathToFileURL(dashboardPath).href;
    await this.page.goto(fileUrl);
    await this.page.waitForLoadState('networkidle');
  }

  async triggerCriticalState() {
    console.log('🧪 Simulating IoT Telemetry Spike...');
    await this.page.evaluate(() => {
      // Direct DOM manipulation to simulate a critical event for testing
      const firstBadge = document.querySelector('.rag-badge, [class*="bg-"]');
      if (firstBadge) {
        firstBadge.className = 'rag-badge bg-red-500 animate-pulse w-3 h-3 rounded-full';
        firstBadge.textContent = 'CRITICAL';
      }
    });
  }
}
