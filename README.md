bigcursor
=========

BigCursor is a macOS menu bar utility that displays an enlarged cursor overlay on
your screen, making your mouse pointer much easier to see.

## How It Works

BigCursor uses a `CGEventTap` (via `CGEventTapCreate`) to listen for
`kCGEventMouseMoved`, `kCGEventLeftMouseDragged`, and
`kCGEventRightMouseDragged` events at the session level. Each time the mouse
moves, the app repositions a borderless, transparent `NSWindow` so that it
sits directly on top of the hardware cursor.

The overlay window is configured with:

- `NSBorderlessWindowMask` – no title bar or chrome
- `clearColor` background with `opaque = NO` – fully transparent except for
  the cursor graphic drawn in the content view
- Window level set to `CGShieldingWindowLevel() + 1` – keeps the overlay
  above virtually all other windows
- Shadow enabled so the enlarged cursor remains visible against bright
  backgrounds

## Accessibility Permission

Because the app uses `CGEventTapCreate`, macOS requires the user to grant
**Accessibility** (Input Monitoring) permission. Since macOS Mojave (10.14)
the Info.plist must also include `NSAppleEventsUsageDescription`; BigCursor
provides the string _"We want to make a big cursor for you!"_ for that key.

If the event tap cannot be created (permission denied), the overlay window
is simply not shown and the app falls back to doing nothing.

## Menu Bar Controls

A status-bar item labelled **"Big Cursor"** provides a small menu:

| Item | Action |
|------|--------|
| **Enabled** | Toggles the big-cursor overlay on or off (check-marked when active) |
| **Quit** | Terminates the application |

## Building

Open `BigCursor.xcodeproj` in Xcode and build the **BigCursor** scheme, or
run from the command line:

```sh
xcodebuild
```

The project targets macOS and is written in Objective-C.
