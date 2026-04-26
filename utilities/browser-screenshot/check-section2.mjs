import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const info = await page.evaluate(() => {
  const sec = document.querySelector('[aria-roledescription="carousel"]');
  const mar = document.querySelector('.marquee-section');
  const html = document.documentElement;
  const body = document.body;
  return {
    secScroll: sec.scrollWidth,
    secClient: sec.clientWidth,
    secOver: window.getComputedStyle(sec).overflow,
    marScroll: mar.scrollWidth,
    marClient: mar.clientWidth,
    marOver: window.getComputedStyle(mar).overflow,
    bodyScroll: body.scrollWidth,
    htmlScroll: html.scrollWidth,
  };
});
console.log(JSON.stringify(info, null, 2));
await browser.close();
