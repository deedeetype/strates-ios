import SwiftUI

@main
struct StratesApp: App {
    @State private var splashTerminé = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if splashTerminé {
                    ContentView()
                        .transition(.opacity)
                } else {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            splashTerminé = true
                        }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: splashTerminé)
        }
    }
}
