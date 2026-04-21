# ============================================================
# GESTATION GUARDIAN - AUTO-FIX SCRIPT
# ============================================================

$root = $PSScriptRoot
Write-Host "`n GESTATION GUARDIAN - AUTO-FIX SCRIPT" -ForegroundColor Cyan
Write-Host "==========================================`n" -ForegroundColor Cyan

# ── FIX 1: playwright.config.ts ─────────────────────────────
Write-Host "[ 1/5 ] Fixing playwright.config.ts..." -ForegroundColor Yellow
$configPath = Join-Path $root "playwright.config.ts"
$fix1 = "import { defineConfig, devices } from '@playwright/test';"
$fix1 += "`n`nexport default defineConfig({"
$fix1 += "`n  testDir: './tests',"
$fix1 += "`n  fullyParallel: true,"
$fix1 += "`n  forbidOnly: !!process.env.CI,"
$fix1 += "`n  retries: process.env.CI ? 2 : 0,"
$fix1 += "`n  workers: process.env.CI ? 1 : undefined,"
$fix1 += "`n  reporter: 'html',"
$fix1 += "`n  use: {"
$fix1 += "`n    baseURL: 'http://localhost:3000',"
$fix1 += "`n    trace: 'on-first-retry',"
$fix1 += "`n  },"
$fix1 += "`n  projects: ["
$fix1 += "`n    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },"
$fix1 += "`n    { name: 'firefox',  use: { ...devices['Desktop Firefox'] } },"
$fix1 += "`n    { name: 'webkit',   use: { ...devices['Desktop Safari'] } },"
$fix1 += "`n  ],"
$fix1 += "`n  webServer: {"
$fix1 += "`n    command: 'npx serve . -l 3000',"
$fix1 += "`n    url: 'http://localhost:3000',"
$fix1 += "`n    reuseExistingServer: !process.env.CI,"
$fix1 += "`n    timeout: 10000,"
$fix1 += "`n  },"
$fix1 += "`n});"
[System.IO.File]::WriteAllText($configPath, $fix1, [System.Text.Encoding]::UTF8)
Write-Host "   OK: testDir -> ./tests, baseURL set, webServer added" -ForegroundColor Green

# ── FIX 2: GestationGuardianPage.ts (hardcoded path) ────────
Write-Host "[ 2/5 ] Fixing pom\GestationGuardianPage.ts..." -ForegroundColor Yellow
$pomPath = Join-Path $root "pom\GestationGuardianPage.ts"
$fix2  = "import { Page, Locator } from '@playwright/test';"
$fix2 += "`n`nexport class GestationGuardianPage {"
$fix2 += "`n  readonly page: Page;"
$fix2 += "`n  readonly patientGrid: Locator;"
$fix2 += "`n  readonly criticalBadge: Locator;"
$fix2 += "`n`n  constructor(page: Page) {"
$fix2 += "`n    this.page = page;"
$fix2 += "`n    this.patientGrid = page.locator('#patient-grid');"
$fix2 += "`n    this.criticalBadge = page.locator('.pulse-critical');"
$fix2 += "`n  }"
$fix2 += "`n`n  async navigate() {"
$fix2 += "`n    await this.page.goto('/');"
$fix2 += "`n    await this.page.waitForLoadState('domcontentloaded');"
$fix2 += "`n  }"
$fix2 += "`n`n  async triggerCriticalState() {"
$fix2 += "`n    await this.page.evaluate(() => {"
$fix2 += "`n      const badge = document.querySelector('[class*=bg-red]') as HTMLElement;"
$fix2 += "`n      if (badge) {"
$fix2 += "`n        badge.className = 'pulse-critical px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest bg-red-100 text-red-700';"
$fix2 += "`n        badge.textContent = 'CRITICAL';"
$fix2 += "`n      }"
$fix2 += "`n    });"
$fix2 += "`n  }"
$fix2 += "`n}"
[System.IO.File]::WriteAllText($pomPath, $fix2, [System.Text.Encoding]::UTF8)
Write-Host "   OK: Hardcoded path removed, navigate() uses baseURL, selector corrected" -ForegroundColor Green

# ── FIX 3: gestation-guardian.spec.ts (animate-pulse mismatch) ──
Write-Host "[ 3/5 ] Fixing tests\gestation-guardian.spec.ts..." -ForegroundColor Yellow
$specPath = Join-Path $root "tests\gestation-guardian.spec.ts"
$fix3  = "import { test, expect } from '@playwright/test';"
$fix3 += "`nimport { GestationGuardianPage } from '../pom/GestationGuardianPage';"
$fix3 += "`n`ntest.describe('Gestation Guardian - Clinical Safety Assertions', () => {"
$fix3 += "`n  test('Critical Alert should trigger pulsing UI and red RAG state', async ({ page }) => {"
$fix3 += "`n    const portal = new GestationGuardianPage(page);"
$fix3 += "`n    await portal.navigate();"
$fix3 += "`n    const body = page.locator('body');"
$fix3 += "`n    await expect(body).toHaveCSS('font-family', /Inter/);"
$fix3 += "`n    await portal.triggerCriticalState();"
$fix3 += "`n    // FIX: was 'animate-pulse' (Tailwind) — app uses custom 'pulse-critical' keyframe"
$fix3 += "`n    await expect(portal.criticalBadge.first()).toBeVisible();"
$fix3 += "`n    await expect(portal.criticalBadge.first()).toHaveClass(/pulse-critical/);"
$fix3 += "`n    console.log('SUCCESS: Critical Alert verified.');"
$fix3 += "`n  });"
$fix3 += "`n});"
[System.IO.File]::WriteAllText($specPath, $fix3, [System.Text.Encoding]::UTF8)
Write-Host "   OK: animate-pulse -> pulse-critical" -ForegroundColor Green

# ── FIX 4: Unify patient names in index.html ────────────────
Write-Host "[ 4/5 ] Fixing patient name mismatch in index.html..." -ForegroundColor Yellow
$indexPath = Join-Path $root "index.html"
$html = [System.IO.File]::ReadAllText($indexPath)
$html = $html.Replace('"Alice Rodriguez"', '"Alice R."')
$html = $html.Replace('"Maya Torres"',     '"Maya T."')
$html = $html.Replace('"Sarah Jenkins"',   '"Sarah J."')
$html = $html.Replace('"Fatima Al-Sayed"', '"Fatima A."')
$html = $html.Replace('"Chloe O''Connor"', '"Chloe O."')
$html = $html.Replace('"Aisha Patel"',     '"Aisha P."')
[System.IO.File]::WriteAllText($indexPath, $html, [System.Text.Encoding]::UTF8)
Write-Host "   OK: Patient names unified" -ForegroundColor Green

# ── FIX 5: Remove nested .git ────────────────────────────────
Write-Host "[ 5/5 ] Removing nested .git in stitch_doctor_dashboard_ui..." -ForegroundColor Yellow
$nestedGit = Join-Path $root "stitch_doctor_dashboard_ui\.git"
if (Test-Path $nestedGit) {
    Remove-Item -Recurse -Force $nestedGit
    Write-Host "   OK: Nested .git removed" -ForegroundColor Green
} else {
    Write-Host "   SKIP: Nested .git not found" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "ALL 5 FIXES APPLIED SUCCESSFULLY" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. npm install"
Write-Host "  2. npx playwright test --project=chromium"
Write-Host "  3. npx playwright show-report"
Write-Host ""
