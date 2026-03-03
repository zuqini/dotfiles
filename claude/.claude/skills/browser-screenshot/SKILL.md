---
name: browser-screenshot
description: "Launch a headless browser, navigate to a URL, take a screenshot, and display it in the conversation. Use when the user asks to screenshot a page, preview a dev server, or visually inspect a web page."
---

Take a screenshot of a web page using Playwright and display it in the conversation.

## Usage

Run the screenshot script from `~/dotfiles/utilities/browser-screenshot/`:

```bash
node ~/dotfiles/utilities/browser-screenshot/screenshot.mjs [options]
```

### Options

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--url` | `-u` | `http://localhost:3000` | URL to screenshot |
| `--output` | `-o` | auto (temp file) | Output file path |
| `--width` | `-w` | `1280` | Viewport width |
| `--height` | `-h` | `720` | Viewport height |
| `--fullpage` | `-f` | `false` | Capture full scrollable page |
| `--wait` | | `networkidle` | Wait strategy: `load`, `domcontentloaded`, `networkidle`, `commit` |
| `--delay` | `-d` | `0` | Extra delay in ms after page load |
| `--selector` | `-s` | | CSS selector to screenshot a specific element |

### Workflow

1. Run the screenshot script via Bash — it prints the output file path to stdout
2. Read the output image file path using the Read tool to display it in the conversation
3. Describe what you see and answer any questions about the page

### Examples

Screenshot the default dev server:
```bash
node ~/dotfiles/utilities/browser-screenshot/screenshot.mjs
```

Screenshot a specific URL at mobile width:
```bash
node ~/dotfiles/utilities/browser-screenshot/screenshot.mjs -u http://localhost:3000/products -w 375 -h 812
```

Full-page screenshot with extra wait time:
```bash
node ~/dotfiles/utilities/browser-screenshot/screenshot.mjs -u http://localhost:4321 --fullpage -d 2000
```

Screenshot a specific component:
```bash
node ~/dotfiles/utilities/browser-screenshot/screenshot.mjs -s ".hero-section"
```

### Setup

If the script fails because dependencies aren't installed, run:
```bash
cd ~/dotfiles/utilities/browser-screenshot && npm install && npx playwright install chromium
```
