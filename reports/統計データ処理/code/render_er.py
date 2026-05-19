#!/usr/bin/env python3
"""Regenerate ER diagram PNG from er-sns.mmd via mermaid.ink."""
import json, base64, zlib, urllib.request, os, sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MMD_FILES = {
    os.path.join(SCRIPT_DIR, "er-sns.mmd"): "er_sns.png",
    os.path.join(SCRIPT_DIR, "er-sns-extended.mmd"): "er_sns_extended.png",
}
IMG_DIR = os.path.join(os.path.dirname(SCRIPT_DIR), "images")


def render(mmd_path: str, out_path: str) -> None:
    with open(mmd_path, "r") as f:
        diagram = f.read().strip()

    payload = json.dumps({"code": diagram, "mermaid": {"theme": "neutral"}})
    compressed = zlib.compress(payload.encode(), 9)
    encoded = base64.urlsafe_b64encode(compressed).decode().rstrip("=")

    url = f"https://mermaid.ink/img/pako:{encoded}?type=png"
    print(f"Fetching from mermaid.ink…")

    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        data = resp.read()

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "wb") as f:
        f.write(data)
    print(f"Saved {len(data)} bytes → {out_path}")


if __name__ == "__main__":
    for mmd_path, png_name in MMD_FILES.items():
        out_path = os.path.join(IMG_DIR, png_name)
        render(mmd_path, out_path)
