from __future__ import annotations

from playwright.async_api import async_playwright


async def render(url: str) -> str:
    """Returns the HTML of a page after its JavaScript has run."""
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        await page.goto(url, wait_until="networkidle")
        html = await page.content()
        await browser.close()
        return html
