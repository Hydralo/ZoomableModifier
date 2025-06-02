# ZoomableViewModifier

[![Swift Package Manager][spm-badge]][spm-link] [![iOS Version][ios-badge]][ios-link] [![License][license-badge]][license-link]

A lightweight SwiftUI package that makes any `View` pinch-to-zoomable, draggable, and double-tap-zoomable. Perfect for images, maps, charts, or any container you want your users to interact with.

---

## 🚀 Overview

`ZoomableViewModifier` is a reusable SwiftUI `ViewModifier` and associated extension that:
- **Pinch-to-zoom:** Support for smooth, anchored magnification gestures on iOS 16 and iOS 17+.
- **Dragging:** Pan around when the content is zoomed in.
- **Double-tap zoom:** Quickly toggle between minimum and maximum scale with a two-finger tap.
- **Bounds clamping:** Prevents over-zooming and panning outside the content’s edges.
- **Easy to use:** Apply via a single `.zoomable(...)` modifier to any SwiftUI `View`.

<p align="center">
  <img src="https://raw.githubusercontent.com/YourGitHubUsername/ZoomableViewModifier/main/Screenshots/zoomable-demo.png" alt="Demo Screenshot" width="600">
</p>

---

## ✨ Features

- **iOS 16 Support:** Uses `MagnificationGesture` with a configurable zoom factor.
- **iOS 17 Support:** Leverages `MagnifyGesture(minimumScaleDelta: 0)` for pixel-perfect anchoring around the user’s pinch point.
- **Dynamic Content-Size Detection:** Automatically measures the `View` size with `GeometryReader` to compute anchor points and clamp boundaries.
- **Built-In Clamping:** Ensures the scale stays within `minZoomScale ... maxZoomScale` and the content never drifts off-screen.
- **Double-Tap Zoom Toggle:** Zoom to a predefined maximum scale or reset to identity with a two-tap gesture.
- **Customizable Zoom Range:** Simply set `minZoomScale` and `maxZoomScale` when you apply the modifier.
- **Optional Out-of-Bounds Background:** Fill the “empty” area around a zoomed view with a custom color or gradient.

---