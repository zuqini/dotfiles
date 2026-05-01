import { chromium } from "playwright";
const url = process.argv[2];
const w = parseInt(process.argv[3] || "375");
const h = parseInt(process.argv[4] || "812");
const out = process.argv[5] || "/tmp/footer-tight.png";
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: w, height: h } });
await page.goto(url, { waitUntil: "networkidle" });
await page.evaluate(async () => {
  const marquee = document.querySelector(".marquee-section");
  if (marquee) marquee.scrollIntoView({ block: "center" });
});
await page.waitForTimeout(500);
await page.screenshot({ path: out });
await browser.close();
console.log(out);
