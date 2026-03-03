#!/usr/bin/env node
import { chromium } from "playwright";
import { parseArgs } from "node:util";
import { mkdtemp, access } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

const { values } = parseArgs({
  options: {
    url: { type: "string", short: "u", default: "http://localhost:3000" },
    output: { type: "string", short: "o" },
    width: { type: "string", short: "w", default: "1280" },
    height: { type: "string", short: "h", default: "720" },
    fullpage: { type: "boolean", short: "f", default: false },
    wait: { type: "string", default: "networkidle" },
    delay: { type: "string", short: "d", default: "0" },
    selector: { type: "string", short: "s" },
  },
});

const outputPath =
  values.output ?? join(await mkdtemp(join(tmpdir(), "screenshot-")), "screenshot.png");

const browser = await chromium.launch();
const page = await browser.newPage({
  viewport: {
    width: parseInt(values.width),
    height: parseInt(values.height),
  },
});

try {
  await page.goto(values.url, { waitUntil: values.wait });

  if (parseInt(values.delay) > 0) {
    await page.waitForTimeout(parseInt(values.delay));
  }

  const screenshotTarget = values.selector ? page.locator(values.selector) : page;
  await screenshotTarget.screenshot({
    path: outputPath,
    fullPage: values.fullpage,
  });

  console.log(outputPath);
} finally {
  await browser.close();
}
