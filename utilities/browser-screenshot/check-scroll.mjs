import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const dims = await page.evaluate(() => ({
  bodyScrollWidth: document.body.scrollWidth,
  htmlScrollWidth: document.documentElement.scrollWidth,
  innerWidth: window.innerWidth,
}));
console.log(JSON.stringify(dims));
await browser.close();
