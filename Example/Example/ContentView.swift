import SwiftUI
import ZoomableModifier

struct ContentView: View {
    var body: some View {
        TabView {
            // 1) Example #1: Zoomable Image
            VStack {
                Text("Image Example")
                    .font(.headline)
                Image("SampleImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .border(Color.gray, width: 1)
                    .zoomable(minZoomScale: 1, maxZoomScale: 4)
            }
            .tabItem {
                Label("Image", systemImage: "photo")
            }
                
            // 2) Example #2: Zoomable Rectangle with Text
            VStack {
                Text("Rectangle Example")
                    .font(.headline)
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 300, height: 200)
                    .overlay(
                        Text("Zoom & Pan Me")
                            .font(.headline)
                            .foregroundColor(.blue)
                    )
                    .border(Color.gray, width: 1)
                    .zoomable(minZoomScale: 1, maxZoomScale: 3)
            }
            .tabItem {
                Label("Text", systemImage: "text.magnifyingglass")
            }
        }
    }
}

#Preview {
    ContentView()
}
