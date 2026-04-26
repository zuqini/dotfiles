import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const info = await page.evaluate(() => {
  const t = document.querySelector(".hero-carousel-track");
  if (!t) return null;
  const cs = window.getComputedStyle(t);
  const r = t.getBoundingClientRect();
  return { position: cs.position, transform: cs.transform, right: r.right, width: r.width };
});
console.log(JSON.stringify(info));
await browser.close();
