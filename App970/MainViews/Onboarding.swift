import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var pageIndex: Int = 0
    
    private let pages: [OnboardingPageModel] = [
        .init(title: "Wellcome",
              subtitle: "Here you will learn about real and slang \nchants used around the world",
              imageName: "onboard1",
              buttonTitle: "Next"),
        .init(title: "Concept Explained",
              subtitle: "Simple 3 steps: Select type → Text \ncreation → Rhythmic adjustment",
              imageName: "onboard2",
              buttonTitle: "Next"),
        .init(title: "Choice of Style",
              subtitle: "Choose the style that suits you best, lots of \noptions and trials",
              imageName: "onboard3",
              buttonTitle: "Start")
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            TabView(selection: $pageIndex) {
                ForEach(pages.indices, id: \.self) { i in
                    OnboardingPageView(model: pages[i], onSkip: { hasSeenOnboarding = true }) {
                        if i < pages.count - 1 {
                            withAnimation { pageIndex += 1 }
                        } else {
                            hasSeenOnboarding = true
                        }
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .all)
        }
        .ignoresSafeArea(edges: .all)
    }
}

struct OnboardingPageModel {
    let title: String
    let subtitle: String
    let imageName: String
    let buttonTitle: String
}

struct OnboardingPageView: View {
    let model: OnboardingPageModel
    var onSkip: (() -> Void)?
    var buttonAction: () -> Void
    
    var body: some View {
        ZStack {
            Image(model.imageName)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { onSkip?() }) {
                        Image("skip")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 40)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 60)
                    .padding(.trailing, 20)
                }
                Spacer()
                VStack(spacing: 12) {
                    Text(model.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(model.subtitle)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white.opacity(0.9))
                        .padding(.horizontal, 22)
                        .lineLimit(4)
                    
                    Button(action: buttonAction) {
                        Text(model.buttonTitle)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryPillButtonStyle())
                    .padding(.horizontal, 28)
                    .padding(.top, 6)
                }
                .padding(.vertical, 20)
                .background(GlassBackground(cornerRadius: 33))
                .padding(.horizontal, 18)
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

struct GlassBackground: View {
    var cornerRadius: CGFloat = 16
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.015))
                .background(.ultraThinMaterial.opacity(0.4))
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white.opacity(0.02))
                .blendMode(.overlay)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
}
struct PrimaryPillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 22)
            .background(
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color(red: 0.9, green: 0.6, blue: 0.2)]),
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing))
                    .opacity(configuration.isPressed ? 0.9 : 1.0)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
