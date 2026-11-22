from __future__ import annotations

from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

from shop_admin.db import get_pool

app = FastAPI()
templates = Jinja2Templates(directory=Path(__file__).parent / "templates")


@app.get("/products", response_class=HTMLResponse)
async def products(request: Request) -> HTMLResponse:
    pool = await get_pool()
    rows = await pool.fetch("SELECT code, name, stock FROM products ORDER BY name")
    return templates.TemplateResponse(request, "products.html", {"products": rows})
