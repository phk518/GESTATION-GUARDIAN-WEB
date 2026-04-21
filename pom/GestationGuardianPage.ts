import { Page, Locator } from '@playwright/test';

export class GestationGuardianPage {
  readonly page: Page;
  readonly patientGrid: Locator;
  readonly criticalBadge: Locator;

  constructor(page: Page) {
    this.page = page;
    this.patientGrid = page.locator('#patient-grid');
    // FIX: was '[class*="bg-red"]' — app uses custom 'pulse-critical' keyframe class
    this.criticalBadge = page.locator('.pulse-critical');
  }

  async navigate() {
    // FIX: was a hardcoded absolute path on one machine
    // Now uses baseURL from playwright.config.ts (http://localhost:3000)
    await this.page.goto('/');
    await this.page.waitForLoadState('domcontentloaded');
  }

  async triggerCriticalState() {
    await this.page.evaluate(() => {
      const badge = document.querySelector('[class*="bg-red"]') as HTMLElement;
      if (badge) {
        badge.className = 'pulse-critical bg-red-100 text-red-700 px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest';
        badge.textContent = 'CRITICAL';
      }
    });
  }
}
