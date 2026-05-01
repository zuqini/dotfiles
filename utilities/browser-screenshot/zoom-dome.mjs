import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
await page.goto("http://localhost:3000/", { waitUntil: "networkidle" });
await page.evaluate(() => {
  const m = document.querySelector(".marquee-section");
  if (m) m.scrollIntoView({ block: "center" });
});
await page.waitForTimeout(500);
const m = await page.$(".marquee-section");
const box = await m.boundingBox();
await page.screenshot({
  path: "/tmp/dome-zoom.png",
  clip: { x: box.x + box.width/2 - 120, y: box.y - 50, width: 240, height: 100 },
});
await browser.close();
console.log("/tmp/dome-zoom.png");
