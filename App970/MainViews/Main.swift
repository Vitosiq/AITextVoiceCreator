import SwiftUI
import AVFoundation

enum MainTab {
    case home, creations, create
}

struct MainView: View {
    @State private var selectedTab: MainTab = .home
    @State private var hideTabBar: Bool = false
    @EnvironmentObject var creationsManager: CreationsManager
    @EnvironmentObject var creationGenerator: CreationGenerator
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                case .home:
                    HomeView(hideTabBar: $hideTabBar, selectedTab: $selectedTab)
                        .ignoresSafeArea()
                case .creations:
                    CreationsView(hideTabBar: $hideTabBar)
                        .environmentObject(creationsManager)
                        .ignoresSafeArea()
                case .create:
                    CreateView(hideTabBar: $hideTabBar)
                        .environmentObject(creationsManager)
                        .environmentObject(creationGenerator)
                        .ignoresSafeArea()
                }
            }
            
            if !hideTabBar {
                CustomBottomBar(selected: $selectedTab)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 16)
            }
        }
    }
}


private enum HomeVariant: Int, CaseIterable {
    case one = 1, two = 2, three = 3
    var audioName: String { "audio\(rawValue)" }
}

private final class HomeAudioDelegate: NSObject, AVAudioPlayerDelegate {
    var onDidFinish: (() -> Void)?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in self?.onDidFinish?() }
    }
}

struct HomeView: View {
    @Binding var hideTabBar: Bool
    @Binding var selectedTab: MainTab
    @State private var topSlot: HomeVariant = .one
    @State private var bottomSlot: HomeVariant = .two
    @State private var bigSlot: HomeVariant = .three
    @State private var audioPlayer: AVAudioPlayer?
    @State private var playbackDelegate: HomeAudioDelegate?
    @State private var isPlaying = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("mainBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        NavigationLink {
                            SettingsView(hideTabBar: $hideTabBar)
                        } label: {
                            Image("settings")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        Text("Home")
                            .font(.title)
                            .foregroundColor(.white)

                        Spacer()
                        NavigationLink {
                            InboxView()
                        } label: {
                            Image("envelope")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding(.horizontal)
                    .padding()
                    .padding(.top, 50)
                    HStack {
                        Text("AI football for the \near — create your \nown fan sound!")
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 50)
                        Spacer()
                    }
                    HStack {
                        Button {
                            selectedTab = .create
                        } label: {
                            Image("createChant")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 40)
                        }
                        .buttonStyle(.plain)
                        Button {
                            selectedTab = .creations
                        } label: {
                            Image("myCreation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 40)
                        }
                        .buttonStyle(.plain)
                    }
                    HStack(alignment: .center, spacing: 16) {
                        VStack(spacing: 10) {
                            Button {
                                swapTopWithBig()
                            } label: {
                                variantSlotView(slot: topSlot)
                            }
                            .buttonStyle(.plain)

                            Button {
                                swapBottomWithBig()
                            } label: {
                                variantSlotView(slot: bottomSlot)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(width: 140)

                        ZStack {
                            Image("variantFraimPlay")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 120)
                            variantImage(for: bigSlot)
                                .frame(width: 160, height: 90)
                                .allowsHitTesting(false)
                            Text(variantLabel(bigSlot))
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .allowsHitTesting(false)
                                .padding(.bottom, 80)
                            Button {
                                togglePlayback()
                            } label: {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                            .offset(x:80, y:60)
                        }
                        .frame(width: 180, height: 120)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onChange(of: bigSlot) { _ in
            stopPlayback()
        }
        .onDisappear {
            stopPlayback()
        }
    }

    private func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        playbackDelegate = nil
        isPlaying = false
    }

    @ViewBuilder
    private func variantSlotView(slot: HomeVariant) -> some View {
        ZStack {
            Image("variantFrame")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 50)
            variantImage(for: slot)
                .frame(width: 130, height: 40)
            Text(variantLabel(slot))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.leading, 15)
        }
        .frame(width: 140, height: 50)
    }

    private func variantLabel(_ variant: HomeVariant) -> String {
        switch variant {
        case .one: return "Variant 1"
        case .two: return "Variant 2"
        case .three: return "Variant 3"
        }
    }

    @ViewBuilder
    private func variantImage(for variant: HomeVariant) -> some View {
        switch variant {
        case .one: Image("variantOne").resizable().scaledToFit()
        case .two: Image("variantTwo").resizable().scaledToFit()
        case .three: Image("variantThree").resizable().scaledToFit()
        }
    }

    private func swapTopWithBig() {
        let t = topSlot
        topSlot = bigSlot
        bigSlot = t
    }

    private func swapBottomWithBig() {
        let b = bottomSlot
        bottomSlot = bigSlot
        bigSlot = b
    }

    private func togglePlayback() {
        if let player = audioPlayer {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying.toggle()
            return
        }
        let audioName = bigSlot.audioName
        guard let url = Bundle.main.url(forResource: audioName, withExtension: "m4a")
            ?? Bundle.main.url(forResource: audioName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            let player = try AVAudioPlayer(contentsOf: url)
            let delegate = HomeAudioDelegate()
            delegate.onDidFinish = { isPlaying = false }
            player.delegate = delegate
            player.prepareToPlay()
            player.play()
            audioPlayer = player
            playbackDelegate = delegate
            isPlaying = true
        } catch {}
    }
}

struct InboxView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var notificationsOn = true
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 25) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    Text("Inbox")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.clear)
                }
                .padding(.top, 60)
                .padding(.horizontal)

                
                Spacer()
                
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
    }
}
