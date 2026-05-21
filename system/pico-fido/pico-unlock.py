#!/usr/bin/env python3
"""Unlock the Pico FIDO.

Prompts for the PIN via popup and performs a PIN verification (getPinToken),
which causes the firmware to decrypt the master key into RAM -- unlocking the
encrypted storage so SSH (touch-only) works until the next power cycle.

To reduce latency, device detection runs in a background thread in parallel
with the popup while the user types the PIN.

Manual usage:    pico-unlock
Automatic usage: triggered by udev/systemd on USB connect.
"""

import glob
import json
import os
import subprocess
import sys
import threading
import time

PICO_VID = 0x2E8A
PICO_PID = 0x10FE
TITLE = "Pico FIDO"


def log(msg):
    print(f"[pico-unlock] {msg}", file=sys.stderr, flush=True)


def fix_environment():
    """Ensures session variables are set when triggered by systemd/udev."""
    os.environ.setdefault("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    runtime = os.environ["XDG_RUNTIME_DIR"]
    os.environ.setdefault("DBUS_SESSION_BUS_ADDRESS", f"unix:path={runtime}/bus")
    if "WAYLAND_DISPLAY" not in os.environ:
        socks = [
            s
            for s in sorted(glob.glob(os.path.join(runtime, "wayland-*")))
            if not s.endswith(".lock")
        ]
        if socks:
            os.environ["WAYLAND_DISPLAY"] = os.path.basename(socks[0])
    os.environ.setdefault("DISPLAY", ":0")


def notify(msg, urgency="normal"):
    subprocess.run(
        [
            "notify-send",
            "-u",
            urgency,
            "-a",
            TITLE,
            "-h",
            "boolean:transient:true",
            TITLE,
            msg,
        ],
        check=False,
    )


def ask_pin():
    """Password popup using the DMS text-input plugin."""
    subprocess.run(
        ["dms", "ipc", "call", "text-input", "openPassword", TITLE, "Pico PIN", ""],
        check=False,
    )
    while True:
        res = subprocess.run(
            ["dms", "ipc", "call", "text-input", "result"],
            capture_output=True,
            text=True,
        )
        try:
            data = json.loads(res.stdout.strip())
        except (json.JSONDecodeError, ValueError):
            log(f"result parse error: {res.stdout!r} {res.stderr!r}")
            time.sleep(0.5)
            continue
        if data.get("state") == "submitted":
            return data.get("value", "")
        if data.get("state") == "cancelled":
            return None
        time.sleep(0.3)


class Prep:
    """Result of background device preparation."""

    dev = None
    client_pin = None
    error = None


def prepare(holder):
    """Thread: imports fido2, finds the device and prepares the ClientPin."""
    try:
        from fido2.ctap2 import Ctap2
        from fido2.ctap2.pin import ClientPin
        from fido2.hid import CtapHidDevice

        deadline = time.monotonic() + 8.0
        while True:
            for dev in CtapHidDevice.list_devices():
                d = dev.descriptor
                if d.vid == PICO_VID and d.pid == PICO_PID:
                    holder.dev = dev
                    holder.client_pin = ClientPin(Ctap2(dev))
                    return
                dev.close()
            if time.monotonic() >= deadline:
                holder.error = "not-found"
                return
            time.sleep(0.4)
    except ImportError:
        holder.error = "no-fido2"
    except Exception as e:
        holder.error = e


def main():
    fix_environment()

    # Prepare the device in the background while the user types the PIN.
    holder = Prep()
    worker = threading.Thread(target=prepare, args=(holder,), daemon=True)
    worker.start()

    pin = ask_pin()
    if pin is None:
        log("cancelled / no PIN")
        return 0
    if not pin:
        notify("Empty PIN.", "critical")
        return 1

    worker.join(timeout=9.0)

    if holder.error == "no-fido2":
        log("python-fido2 not installed")
        notify("python-fido2 not installed.", "critical")
        return 1
    if holder.error == "not-found" or holder.dev is None:
        log(f"device unavailable ({holder.error})")
        notify("Pico FIDO not found.", "critical")
        return 1
    if holder.error is not None:
        log(f"preparation error: {holder.error!r}")
        notify(f"Error: {holder.error}", "critical")
        return 1

    from fido2.ctap import CtapError
    from fido2.ctap2.pin import ClientPin

    try:
        holder.client_pin.get_pin_token(
            pin, permissions=ClientPin.PERMISSION.CREDENTIAL_MGMT
        )
    except CtapError as e:
        code = e.code
        if code == CtapError.ERR.PIN_INVALID:
            try:
                left = holder.client_pin.get_pin_retries()[0]
            except Exception:
                left = "?"
            log(f"wrong PIN, retries left: {left}")
            notify(f"Wrong PIN. Retries left: {left}", "critical")
        elif code == CtapError.ERR.PIN_AUTH_BLOCKED:
            notify("PIN blocked for this session. Reconnect the Pico.", "critical")
        elif code == CtapError.ERR.PIN_BLOCKED:
            notify("PIN blocked. The Pico needs a reset.", "critical")
        else:
            log(f"ctap error: {e}")
            notify(f"Unlock failed: {code.name}", "critical")
        return 1
    except Exception as e:
        log(f"error: {e!r}")
        notify(f"Error unlocking: {e}", "critical")
        return 1
    finally:
        holder.dev.close()

    log("storage unlocked")
    notify("Storage unlocked - SSH ready.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
