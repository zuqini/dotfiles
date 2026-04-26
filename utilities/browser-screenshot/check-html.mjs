import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const info = await page.evaluate(() => {
  const html = document.documentElement;
  const body = document.body;
  return {
    htmlOverflow: window.getComputedStyle(html).overflowX,
    bodyOverflow: window.getComputedStyle(body).overflowX,
    htmlScrollW: html.scrollWidth,
    htmlClientW: html.clientWidth,
  };
});
console.log(JSON.stringify(info));
await browser.close();
