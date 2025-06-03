# ZoomableViewModifier

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)

A lightweight SwiftUI package that makes any `View` pinch-to-zoomable, draggable, and double-tap-zoomable. Perfect for images, maps, charts, or any container you want your users to interact with.

![zoomable-demo](https://github.com/user-attachments/assets/ca586a48-6be9-46bb-8113-e3dc129b16e9)

---

## 🚀 Overview

`ZoomableViewModifier` is a reusable SwiftUI `ViewModifier` and associated extension that:
- **Pinch-to-zoom:** Support for smooth, anchored magnification gestures on iOS 16 and iOS 17+.
- **Dragging:** Pan around when the content is zoomed in.
- **Double-tap zoom:** Quickly toggle between minimum and maximum scale with a two-finger tap.
- **Bounds clamping:** Prevents over-zooming and panning outside the content’s edges.
- **Easy to use:** Apply via a single `.zoomable(...)` modifier to any SwiftUI `View`.

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

🤝 Contributions

Contributions, issues, and feature requests are welcome! Feel free to:

Fork the repository.
Create a new branch (git checkout -b feature/YourFeature).
Commit your changes (git commit -m "Add your feature").
Push to the branch (git push origin feature/YourFeature).
Open a Pull Request.
Please make sure to follow Swift API design guidelines and keep code formatting consistent.

---

📝 License

ZoomableViewModifier is released under the MIT License.
Feel free to use, modify, and distribute it in your projects.

---

⚡️ Acknowledgments

Inspired by various SwiftUI gesture demos and community contributions.
Built and tested on iOS 16 and iOS 17 beta.
