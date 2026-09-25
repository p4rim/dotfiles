#!/usr/bin/env python3
"""Cycle current-workspace windows in spatial order, then floating windows."""
import json
import subprocess
import sys


def target_window(windows, direction):
    focused = next((w for w in windows if w["is_focused"]), None)
    if focused is None:
        return None
    current = [w for w in windows if w["workspace_id"] == focused["workspace_id"]]

    def order(window):
        position = window.get("layout", {}).get("pos_in_scrolling_layout")
        return (0, *position, window["id"]) if position else (1, 0, 0, window["id"])

    current.sort(key=order)
    index = next(i for i, w in enumerate(current) if w["id"] == focused["id"])
    return current[(index + direction) % len(current)]["id"]


if __name__ == "__main__":
    windows = json.loads(subprocess.check_output(["niri", "msg", "-j", "windows"]))
    target = target_window(windows, -1 if sys.argv[1:] == ["previous"] else 1)
    if target is not None:
        subprocess.run(["niri", "msg", "action", "focus-window", "--id", str(target)], check=True)
