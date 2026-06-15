#!/usr/bin/env python3
"""Build configured binary PRG assets and add them to a D64 image."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


def fail(message: str) -> None:
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)


def parse_load_address(value: object) -> int:
    if isinstance(value, int):
        addr = value
    elif isinstance(value, str):
        cleaned = value.strip()

        # Supports "00 C0" (little-endian bytes), "0xC000", and "C000".
        parts = cleaned.split()
        if len(parts) == 2:
            low = int(parts[0], 16)
            high = int(parts[1], 16)
            addr = (high << 8) | low
        elif cleaned.lower().startswith("0x"):
            addr = int(cleaned, 16)
        else:
            addr = int(cleaned, 16)
    else:
        fail(f"Unsupported loadAddress type: {type(value).__name__}")

    if addr < 0 or addr > 0xFFFF:
        fail(f"loadAddress out of range: {addr}")
    return addr


def main() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    c64_root = repo_root / "c64"
    build_dir = c64_root / "build"
    d64_path = build_dir / "basic-template.d64"
    config_path = repo_root / "config.json"

    if not config_path.exists():
        fail(f"Missing config file: {config_path}")
    if not d64_path.exists():
        fail(f"Missing D64 image: {d64_path}")

    with config_path.open("r", encoding="utf-8") as handle:
        config = json.load(handle)

    binaries = config.get("binaries", [])
    if not isinstance(binaries, list):
        fail("config.json field 'binaries' must be an array")
    if not binaries:
        print("No configured binaries found; nothing to add.")
        return

    build_dir.mkdir(parents=True, exist_ok=True)

    for entry in binaries:
        if not isinstance(entry, dict):
            fail("Each binaries entry must be an object")

        path = entry.get("path")
        load_address = entry.get("loadAddress")
        disk_name = entry.get("discName") or entry.get("diskName")

        if not path:
            fail("binaries entry is missing 'path'")
        if load_address is None:
            fail(f"binaries entry '{path}' is missing 'loadAddress'")
        if not disk_name:
            fail(f"binaries entry '{path}' is missing 'discName' or 'diskName'")

        source_file = repo_root / str(path)
        if not source_file.exists():
            fail(f"Source binary not found: {source_file}")

        data = source_file.read_bytes()
        addr = parse_load_address(load_address)
        prg_name = f"{str(disk_name).lower()}.prg"
        prg_path = build_dir / prg_name

        # PRG payload starts with little-endian load address.
        prg_path.write_bytes(bytes((addr & 0xFF, (addr >> 8) & 0xFF)) + data)

        cmd = [
            "c1541",
            str(d64_path),
            "-delete",
            str(disk_name),
            "-write",
            str(prg_path),
            str(disk_name),
        ]

        try:
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        except subprocess.CalledProcessError:
            # File might not exist yet; retry without delete.
            write_cmd = [
                "c1541",
                str(d64_path),
                "-write",
                str(prg_path),
                str(disk_name),
            ]
            subprocess.run(write_cmd, check=True)

        print(f"Added {source_file.name} -> {prg_path.name} @ ${addr:04X} as '{disk_name}'")


if __name__ == "__main__":
    main()