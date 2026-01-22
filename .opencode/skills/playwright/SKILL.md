---
name: playwright-automation
description: Best practices for using Playwright MCP tools to browse the web, scrape data, and automate browser actions.
---

# Playwright Automation Guide

Use this guide when you need to access the internet, scrape websites, or test web applications using the Playwright MCP server.

## 1. Tool Naming Convention
The Playwright tools are usually prefixed with `Playwright_` or `browser_` depending on your configuration. 
*   **Common Tools:** `Playwright_navigate`, `Playwright_click`, `Playwright_fill`, `Playwright_screenshot`, `Playwright_evaluate`.
*   **Discovery:** If you are unsure of the exact tool name, run the `mcp.list_tools` command first to see what is available.

## 2. Standard Workflow

### Step A: Navigation
Always start by navigating to the target URL.
*   **Tool:** `Playwright_navigate`
*   **Best Practice:** Set `headless: true` unless debugging visually.
*   **Example:**
    ```json
    {
      "url": "https://example.com",
      "headless": true
    }
    ```

### Step B: Verification & State
After navigating, **do not assume the page is ready**.
1.  **Take a Screenshot:** Use `Playwright_screenshot` immediately to verify you aren't blocked (e.g., by a captcha or login screen).
2.  **Check Console:** If the page is blank, check for errors using `Playwright_evaluate` to read `window.console` logs if available.

### Step C: Interaction (Selectors)
Playwright relies on **Selectors** to find elements.
*   **Text Selectors:** `text="Login"` (Robust)
*   **CSS Selectors:** `.submit-btn`, `#username` (Standard)
*   **Role Selectors:** Locating by accessibility role is preferred.
    *   *Bad:* `button[class="btn-primary"]`
    *   *Good:* `internal:role=button[name="Submit"]`

**Filling Forms:**
Use `Playwright_fill` for inputs and `Playwright_click` for buttons.

### Step D: Extraction
To read data from the page, you often need to run JavaScript.
*   **Tool:** `Playwright_evaluate`
*   **Usage:** Pass a JavaScript function string to return the data you need.
    ```javascript
    // Example: Extract all links
    Array.from(document.querySelectorAll('a')).map(a => a.href)
    ```

## 3. Troubleshooting
*   **Timeouts:** If a tool fails with a timeout, the element might not be visible yet. Use `Playwright_evaluate` to check `document.readyState` or wait explicitly.
*   **Popups/Modals:** If you cannot click an element, a modal might be obscuring it. Take a screenshot to confirm.