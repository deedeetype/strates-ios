import SwiftUI

@main
struct StratesApp: App {
    @State private var splashTerminé  = false
    @State private var onboardingFait = UserDefaults.standard.bool(forKey: "onboardingFait")
    @State private var jeuPrêt       = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if jeuPrêt {
                    ContentView()
                        .transition(.opacity)

                } else if splashTerminé && !onboardingFait {
                    OnboardingView {
                        onboardingFait = true
                        // Demander permission notifications après onboarding
                        NotificationManager.shared.demanderPermission()
                        withAnimation(.easeInOut(duration: 0.4)) { jeuPrêt = true }
                    }
                    .transition(.opacity)

                } else if splashTerminé {
                    ContentView()
                        .transition(.opacity)
                        .onAppear { jeuPrêt = true }

                } else {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) { splashTerminé = true }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: splashTerminé)
            .animation(.easeInOut(duration: 0.4), value: jeuPrêt)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                NotificationManager.shared.reinitialiserBadge()
            }
        }
    }
}
