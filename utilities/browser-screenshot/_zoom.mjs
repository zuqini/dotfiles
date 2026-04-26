import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 1500 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
await page.waitForTimeout(1500);
const aside = await page.locator('aside[aria-label="Product filters"]');
console.log("box:", await aside.boundingBox());
// Take screenshot of area around the aside
await page.screenshot({ path: "/tmp/shop-area.png", clip: { x: 0, y: 200, width: 1280, height: 1100 } });
// Also screenshot the inner div directly
const inner = page.locator('aside[aria-label="Product filters"] details > div');
console.log("inner box:", await inner.boundingBox());
await inner.screenshot({ path: "/tmp/sidebar-only.png" });
await browser.close();
