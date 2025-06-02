import SwiftUI

// Block based wrapper to allow conditional modification
public extension View {
    @ViewBuilder
    func modifyBlock(@ViewBuilder _ block: (Self) -> some View) -> some View {
        block(self)
    }
}
