import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const info = await page.evaluate(() => {
  const sec = document.querySelector('[aria-roledescription="carousel"]');
  if (!sec) return null;
  const cs = window.getComputedStyle(sec);
  return { overflow: cs.overflow, overflowX: cs.overflowX, overflowY: cs.overflowY };
});
console.log(JSON.stringify(info));
await browser.close();
