#!/bin/bash

# @vicinae.schemaVersion 1
# @vicinae.title Lock Keyboard
# @vicinae.mode compact
# @vicinae.packageName Utilities
# @vicinae.icon 🧽
# @vicinae.argument1 { "type": "text", "placeholder": "Seconds (60)", "optional": true }
# @vicinae.description Ignore all keyboard input so the keyboard can be cleaned. ⌃⌥⌘L unlocks early

max_duration=600
duration=${1:-60}
if ! [[ "$duration" =~ ^[0-9]+$ ]] || (( duration < 1 || duration > max_duration )); then
  echo "Duration must be 1-${max_duration} seconds"
  exit 1
fi

# The event tap needs a native process, so compile the Swift below once and cache it by source hash
src=$(cat <<'SWIFT'
import Cocoa

let unlockKeyCode: Int64 = 37 // kVK_ANSI_L
let unlockFlags: CGEventFlags = [.maskControl, .maskAlternate, .maskCommand]
let modifierMask: CGEventFlags = [.maskControl, .maskAlternate, .maskCommand, .maskShift]
let systemDefinedType: UInt32 = 14 // NX_SYSDEFINED: media, volume and brightness keys

if CommandLine.arguments.contains("--check") {
  let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
  exit(AXIsProcessTrustedWithOptions(options) ? 0 : 1)
}

let duration = TimeInterval(CommandLine.arguments.dropFirst().first ?? "") ?? 60
let deadline = Date().addingTimeInterval(duration)
var tap: CFMachPort?
var finishing = false

@MainActor func finish() {
  guard !finishing else { return }
  finishing = true
  if let tap { CGEvent.tapEnable(tap: tap, enable: false) }
  NSSound(named: "Glass")?.play()
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { exit(0) }
}

let eventMask: CGEventMask =
  (1 << CGEventType.keyDown.rawValue) |
  (1 << CGEventType.keyUp.rawValue) |
  (1 << CGEventType.flagsChanged.rawValue) |
  (1 << systemDefinedType)

tap = CGEvent.tapCreate(
  tap: .cghidEventTap,
  place: .headInsertEventTap,
  options: .defaultTap,
  eventsOfInterest: eventMask,
  callback: { _, type, event, _ in
    switch type {
    case .tapDisabledByTimeout, .tapDisabledByUserInput:
      if let tap, !finishing { CGEvent.tapEnable(tap: tap, enable: true) }
      return Unmanaged.passUnretained(event)
    case .keyDown:
      if event.getIntegerValueField(.keyboardEventKeycode) == unlockKeyCode,
         event.flags.intersection(modifierMask) == unlockFlags {
        DispatchQueue.main.async { finish() }
      }
    default:
      break
    }
    return nil
  },
  userInfo: nil
)

guard let tap else {
  FileHandle.standardError.write("Could not create event tap. Grant Accessibility access to the launcher.\n".data(using: .utf8)!)
  exit(1)
}
CFRunLoopAddSource(CFRunLoopGetMain(), CFMachPortCreateRunLoopSource(nil, tap, 0), .commonModes)
CGEvent.tapEnable(tap: tap, enable: true)

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let size = NSSize(width: 380, height: 56)
let panel = NSPanel(
  contentRect: NSRect(origin: .zero, size: size),
  styleMask: [.borderless, .nonactivatingPanel],
  backing: .buffered,
  defer: false
)
panel.level = .screenSaver
panel.isOpaque = false
panel.backgroundColor = .clear
panel.ignoresMouseEvents = true
panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

let background = NSVisualEffectView(frame: NSRect(origin: .zero, size: size))
background.material = .hudWindow
background.state = .active
background.wantsLayer = true
background.layer?.cornerRadius = 12
panel.contentView = background

let label = NSTextField(labelWithString: "")
label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .medium)
label.alignment = .center
label.frame = NSRect(x: 0, y: (size.height - 20) / 2, width: size.width, height: 20)
background.addSubview(label)

if let screen = NSScreen.main?.visibleFrame {
  panel.setFrameOrigin(NSPoint(x: screen.midX - size.width / 2, y: screen.maxY - size.height - 24))
}
panel.orderFrontRegardless()

@MainActor func render() {
  let remaining = Int(deadline.timeIntervalSinceNow.rounded(.up))
  if remaining <= 0 { return finish() }
  label.stringValue = String(format: "Keyboard locked  %d:%02d  ·  ⌃⌥⌘L to unlock", remaining / 60, remaining % 60)
}
MainActor.assumeIsolated { render() }
Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in MainActor.assumeIsolated { render() } }

signal(SIGTERM) { _ in exit(0) }
app.run()
SWIFT
)

cache="$HOME/Library/Caches/keyboard-lock"
hash=$(printf '%s' "$src" | shasum | cut -c1-12)
bin="$cache/keyboard-lock-$hash"

if [ ! -x "$bin" ]; then
  mkdir -p "$cache"
  rm -f "$cache"/keyboard-lock-*
  printf '%s\n' "$src" > "$cache/main.swift"
  if ! swiftc -O "$cache/main.swift" -o "$bin" 2>"$cache/build.log"; then
    echo "Build failed, see $cache/build.log"
    exit 1
  fi
fi

if ! "$bin" --check; then
  echo "Grant Accessibility access to the launcher, then run again"
  exit 1
fi

pkill -f "$cache/keyboard-lock-" 2>/dev/null
nohup "$bin" "$duration" >/dev/null 2>&1 &

echo "Keyboard locked for ${duration}s. ⌃⌥⌘L to unlock"
