import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/shop", { waitUntil: "networkidle" });
const wide = await page.evaluate(() => {
  const all = Array.from(document.querySelectorAll("*"));
  return all
    .map((el) => {
      const r = el.getBoundingClientRect();
      const inCarousel = el.closest('[aria-roledescription="carousel"]');
      const inMarquee = el.closest('.marquee-section');
      return { tag: el.tagName, cls: (el.className || "").toString().slice(0, 80), right: r.right, width: r.width, in: inCarousel ? 'carousel' : inMarquee ? 'marquee' : 'other' };
    })
    .filter((x) => x.right > 1300 && x.in === 'other')
    .sort((a, b) => b.right - a.right)
    .slice(0, 10);
});
console.log(JSON.stringify(wide, null, 2));
await browser.close();
