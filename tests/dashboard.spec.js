const { test, expect } = require('@playwright/test');

// Standard URL for local dev
const LOCAL_URL = 'http://localhost:3000';

test.describe('Gestation Guardian - Core Triage Flows', () => {

  test.beforeEach(async ({ page }) => {
    // Navigate to the dashboard before each test
    await page.goto(LOCAL_URL);
  });

  test('Agent Pass 1: Initial Load & Telemetry Integrity', async ({ page }) => {
    // Verify the app loads the correct title
    await expect(page).toHaveTitle(/Master Dashboard/);
    
    // Verify the live clock is ticking (checking for the LIVE badge)
    await expect(page.getByText('LIVE', { exact: true })).toBeVisible();

    // Verify all 8 simulated patients loaded on the initial grid
    await expect(page.locator('#patient-count')).toHaveText('8');
  });

  test('Agent Pass 2: RAG Triage Filter Engine', async ({ page }) => {
    // Click the 'Critical' filter toggle
    await page.locator('#filter-Critical').click();

    // Verify the active state styling switched to the Critical button
    await expect(page.locator('#filter-Critical')).toHaveClass(/bg-silver-300/);
    
    // Verify the patient count updates (we have 2 critical patients in the mock data)
    await expect(page.locator('#patient-count')).toHaveText('2');

    // Ensure Maya Torres (Critical) is visible, but Sarah Jenkins (Stable) is hidden
    await expect(page.getByText('Maya Torres')).toBeVisible();
    await expect(page.getByText('Sarah Jenkins')).not.toBeVisible();
  });

  test('Agent Pass 3: Search Engine Precision', async ({ page }) => {
    // Type into the search bar
    await page.locator('#search-input').fill('RPM-112');

    // Verify the grid filters down to exactly 1 patient
    await expect(page.locator('#patient-count')).toHaveText('1');
    await expect(page.getByText("Chloe O'Connor")).toBeVisible();
  });

  test('Agent Pass 4: Slide-out Intervention Panel Activation', async ({ page }) => {
    // Locate and click Maya Torres's card
    await page.getByText('Maya Torres').click();

    // Verify the slide-out panel animates in
    const panel = page.locator('#intervention-panel');
    await expect(panel).not.toHaveClass(/translate-x-full/);

    // Verify the data successfully populated the deep-dive panel
    await expect(page.locator('#panel-name')).toHaveText('Maya Torres');
    await expect(page.locator('#panel-status-text')).toHaveText('Critical');
    
    // Ensure the Fetal HR data populated
    await expect(page.locator('#panel-fhr')).not.toHaveText('--');

    // Close the panel and verify it hides
    await page.getByRole('button', { name: 'close' }).click();
    await expect(panel).toHaveClass(/translate-x-full/);
  });

});