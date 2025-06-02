import SwiftUI

public struct ZoomableModifier: ViewModifier {
    let minZoomScale: CGFloat
    let maxZoomScale: CGFloat

    @State private var lastTransform: CGAffineTransform = .identity
    @State private var transform: CGAffineTransform = .identity
    @State private var contentSize: CGSize = .zero

    public func body(content: Content) -> some View {
        content
            .background(alignment: .topLeading) {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            contentSize = proxy.size
                        }
                }
            }
            .animatableTransformEffect(transform)
            .gesture(dragGesture, including: transform == .identity ? .none : .all)
            .modifyBlock { view in
                // iOS 16: Due to limitations with MagnificationGesture, during pinch-in actions, the zoom location is fixed to the top-left corner.
                // iOS 17 and later: This issue has been addressed and improved with the introduction of MagnifyGesture.
                if #available(iOS 17.0, *) {
                    view.gesture(magnificationGesture)
                } else {
                    view.gesture(oldMagnificationGesture)
                }
            }
            .gesture(doubleTapGesture)
    }

    @available(iOS, introduced: 16.0, deprecated: 17.0)
    private var oldMagnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let zoomFactor = 0.5
                let scale = value * zoomFactor
                transform = lastTransform.scaledBy(x: scale, y: scale)
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    @available(iOS 17.0, *)
    private var magnificationGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .onChanged { value in
                let newTransform = CGAffineTransform.anchoredScale(
                    scale: value.magnification,
                    anchor: value.startAnchor.scaledBy(contentSize)
                )
                transform = lastTransform.concatenating(newTransform)
            }
            .onEnded { _ in
                withAnimation(.interactiveSpring()) {
                    onEndGesture()
                }
            }
    }

    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { value in
                let newTransform: CGAffineTransform =
                    if transform.isIdentity {
                    .anchoredScale(scale: maxZoomScale, anchor: value.location)
                } else {
                    .identity
                }

                withAnimation(.linear(duration: 0.15)) {
                    transform = newTransform
                    lastTransform = newTransform
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring) {
                    transform = lastTransform.translatedBy(
                        x: value.translation.width / transform.scaleX,
                        y: value.translation.height / transform.scaleY
                    )
                }
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    private func onEndGesture() {
        let newTransform = limitTransform(transform)

        withAnimation(.snappy(duration: 0.1)) {
            transform = newTransform
            lastTransform = newTransform
        }
    }

    private func limitTransform(_ transform: CGAffineTransform) -> CGAffineTransform {
        let scaleX = transform.scaleX
        let scaleY = transform.scaleY

        // Limit scale to min and max zoom levels
        if scaleX < minZoomScale || scaleY < minZoomScale {
            return .identity
        }

        if scaleX > maxZoomScale || scaleY > maxZoomScale {
            let anchor = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
            return .anchoredScale(scale: maxZoomScale, anchor: anchor)
        }

        // Calculate maximum translation values based on content size and scale
        let maxX = contentSize.width * (scaleX - 1)
        let maxY = contentSize.height * (scaleY - 1)
        
        // Limit translation to prevent content from going out of bounds
        let clampedTx = (-maxX ... 0).clamp(transform.tx)
        let clampedTy = (-maxY ... 0).clamp(transform.ty)

        // Return a new transform with clamped translation values
        var clampedTransform = transform
        clampedTransform.tx = clampedTx
        clampedTransform.ty = clampedTy
        return clampedTransform
    }
}

// MARK: - Public View extension

public extension View {
    @ViewBuilder
    func zoomable(
        minZoomScale: CGFloat = 1,
        maxZoomScale: CGFloat = 3
    ) -> some View {
        modifier(ZoomableModifier(
            minZoomScale: minZoomScale,
            maxZoomScale: maxZoomScale
        ))
    }

    @ViewBuilder
    func zoomable(
        minZoomScale: CGFloat = 1,
        maxZoomScale: CGFloat = 3,
        outOfBoundsColor: Color = .clear
    ) -> some View {
        GeometryReader { _ in
            ZStack {
                outOfBoundsColor
                self.zoomable(
                    minZoomScale: minZoomScale,
                    maxZoomScale: maxZoomScale
                )
            }
        }
    }
}

// MARK: - Private View extension

private extension View {
    @ViewBuilder
    func animatableTransformEffect(_ transform: CGAffineTransform) -> some View {
        scaleEffect(
            x: transform.scaleX,
            y: transform.scaleY,
            anchor: .zero
        )
        .offset(x: transform.tx, y: transform.ty)
    }
}

// MARK: - Private UnitPoint extension

private extension UnitPoint {
    func scaledBy(_ size: CGSize) -> CGPoint {
        .init(
            x: x * size.width,
            y: y * size.height
        )
    }
}

// MARK: - Private CGAffineTransform extension

private extension CGAffineTransform {
    static func anchoredScale(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        CGAffineTransform(translationX: anchor.x, y: anchor.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -anchor.x, y: -anchor.y)
    }

    var scaleX: CGFloat {
        sqrt(a * a + c * c)
    }

    var scaleY: CGFloat {
        sqrt(b * b + d * d)
    }
}

private extension ClosedRange<CGFloat> {
    func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, lowerBound), upperBound)
    }
}

// Block based wrapper to allow conditional modification
public extension View {
    @ViewBuilder
    func modifyBlock(@ViewBuilder _ block: (Self) -> some View) -> some View {
        block(self)
    }
}
