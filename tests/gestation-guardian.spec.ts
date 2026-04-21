import { test, expect } from '@playwright/test';
import { GestationGuardianPage } from '../pom/GestationGuardianPage';

test.describe('Gestation Guardian - Clinical Safety Assertions', () => {
  test('Critical Alert should trigger pulsing UI and red RAG state', async ({ page }) => {
    const portal = new GestationGuardianPage(page);
    await portal.navigate();

    // 1. Verify Inter font is applied (clinical requirement)
    const body = page.locator('body');
    await expect(body).toHaveCSS('font-family', /Inter/);

    // 2. Trigger the Triage Event
    await portal.triggerCriticalState();

    // 3. Assert the RAG Logic
    // FIX: was 'animate-pulse' (Tailwind utility) — app uses custom 'pulse-critical' keyframe
    await expect(portal.criticalBadge.first()).toBeVisible();
    await expect(portal.criticalBadge.first()).toHaveClass(/pulse-critical/);

    console.log('SUCCESS: Critical Alert verified in the UI.');
  });
});
