from __future__ import annotations

from fastapi.testclient import TestClient

from shop_admin.web.app import app


def test_products_links_each_row(fresh_db: None) -> None:
    client = TestClient(app)
    response = client.get("/products")
    assert response.status_code == 200
    assert 'href="/products/SKU-1"' in response.text
    assert "stretched-link" in response.text
