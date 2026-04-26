import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const can = await page.evaluate(() => {
  // Check if user can horizontal scroll
  window.scrollTo(2000, 0);
  return { scrollX: window.scrollX, maxScroll: document.documentElement.scrollWidth - window.innerWidth };
});
console.log(JSON.stringify(can));
await browser.close();
