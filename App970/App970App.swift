import SwiftUI

@main
struct AppStart: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @StateObject private var creationsManager = CreationsManager()
    @StateObject private var creationGenerator = CreationGenerator(aiService: GroqTextGenerationService())
    var body: some View {
        Group {
            if hasSeenOnboarding {
                MainView()
                    .environmentObject(creationsManager)
                    .environmentObject(creationGenerator)
            } else {
                OnboardingContainerView()
            }
        }
    }
}
