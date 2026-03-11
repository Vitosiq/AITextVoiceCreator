import SwiftUI
import AVFoundation

struct CreationsView: View {
    @Binding var hideTabBar: Bool
    @EnvironmentObject var creationsManager: CreationsManager
    @State private var selectedFilter: String = "All"
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                    VStack(spacing: 0) {
                        HStack {
                            NavigationLink {
                                SettingsView(hideTabBar: $hideTabBar)
                            } label: {
                                Image("settings")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                            Text("My Сreations")
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
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            AllCreationsSection(selectedFilter: $selectedFilter)
                                .environmentObject(creationsManager)
                                .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 600)
                        .padding(.top, 15)
                        Spacer()
                    }
                
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct AllCreationsSection: View {
    @EnvironmentObject var creationsManager: CreationsManager
    @Binding var selectedFilter: String

    @State private var selectedCreation: Creation?
    @State private var isNavigationActive = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("All Creations")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.trailing, 40)
            }
            .padding(.bottom, 20)
            .padding(.top, 10)

            if creationsManager.creations.isEmpty {
                EmptyCreationsView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)

                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(Array(creationsManager.creations.enumerated()), id: \.element.id) { index, creation in
                        CreationRowView(
                            creation: creation,
                            index: index + 1,
                            total: creationsManager.creations.count,
                            onOpen: {
                                selectedCreation = creation
                                isNavigationActive = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }

            NavigationLink(
                destination: navigationDestination,
                isActive: $isNavigationActive
            ) {
            }
        }
    }

    @ViewBuilder
    private var navigationDestination: some View {
        if let creation = selectedCreation {
            CreationView(creation: creation)
        } else {
            InboxView()
        }
    }
}

struct CreationRowView: View {
    let creation: Creation
    let index: Int
    let total: Int
    @EnvironmentObject var creationsManager: CreationsManager
    @State private var showDeleteAlert = false
    @State private var showActionMenu = false
    let onOpen: () -> Void

    private var menuBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.12, green: 0.16, blue: 0.35))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }

    var body: some View {
        VStack {
            HStack() {
                Spacer()
                Text(creation.type.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.05, green: 0.08, blue: 0.25))
                    .clipShape(Capsule())
                
                Text(creation.dateString)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .padding(.trailing, 70)
                
                
                Text("\(index)/\(total)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.leading, 20)
                    .padding(.bottom, 5)
                Spacer()
            }
            
            HStack {
                Spacer()

                Button(action: { onOpen() }) {
                    Text("Open")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.15, green: 0.2, blue: 0.5))
                        .clipShape(Capsule())
                }
                
                Button(action: { showActionMenu = true }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(red: 0.15, green: 0.2, blue: 0.5))
                        .clipShape(Circle())
                }
                Spacer()
            }.padding(.leading, 150)

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background((Image("frameCreations")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 100)))
        .overlay {
            if showActionMenu {
                ZStack(alignment: .topTrailing) {
                    Color.clear.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { showActionMenu = false }
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            showActionMenu = false
                            onOpen()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text("Open")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal, 8)
                        Button(action: {
                            showActionMenu = false
                            UIPasteboard.general.string = creation.text
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text("Copy text")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal, 8)
                        Button(action: {
                            showActionMenu = false
                            showDeleteAlert = true
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal, 8)
                        Button(action: { showActionMenu = false }) {
                            HStack(spacing: 10) {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                Text("Close")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                    }
                    .background(menuBackground)
                    .frame(width: 180)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                }
            }
        }
        .alert("Delete Creation", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                creationsManager.deleteCreation(creation)
            }
        } message: {
            Text("Are you sure you want to delete this creation?")
        }
    }
}

struct EmptyCreationsView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "music.note.list")
                .font(.system(size: 30))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No Creations Yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Create your first screamer, speech, slogan or song!")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private final class AudioPlaybackDelegate: NSObject, AVAudioPlayerDelegate {
    var onDidFinish: (() -> Void)?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in self?.onDidFinish?() }
    }
}

private final class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    var onDidFinish: (() -> Void)?
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in self?.onDidFinish?() }
    }
}

private let creationCountries: [(String, String)] = [
    ("USA", "🇺🇸"),
    ("UK", "🇬🇧"),
    ("Germany", "🇩🇪"),
    ("France", "🇫🇷"),
    ("Spain", "🇪🇸"),
    ("Italy", "🇮🇹")
]

private struct LanguagePickerSheet: View {
    let countries: [(String, String)]
    @Binding var selectedCountry: String
    var onDismiss: () -> Void

    private let blueBackground = Color(red: 0.05, green: 0.08, blue: 0.25)
    private let blueRow = Color(red: 0.12, green: 0.18, blue: 0.45)
    private let blueRowSelected = Color(red: 0.18, green: 0.25, blue: 0.55)

    var body: some View {
        ZStack {
            blueBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Translate to")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") {
                        onDismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.orange)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(countries, id: \.0) { country in
                            Button(action: {
                                selectedCountry = country.0
                                onDismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Text(country.1)
                                        .font(.system(size: 22))
                                    Text(country.0)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    Spacer()
                                    if selectedCountry == country.0 {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedCountry == country.0 ? blueRowSelected : blueRow)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

struct CreationView: View {
    let creation: Creation
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer?
    @State private var playbackDelegate: AudioPlaybackDelegate?
    @State private var isPlaying: Bool = false
    @State private var speechSynthesizer: AVSpeechSynthesizer?
    @State private var speechDelegate: SpeechDelegate?
    @State private var isSpeaking: Bool = false
    @State private var showTranslatePicker: Bool = false
    @State private var selectedTranslateCountry: String = "USA"
    @State private var translatedText: String?
    @State private var isTranslating: Bool = false
    @State private var translationError: String?
    @State private var showTranslationAlert: Bool = false

    private var displayedText: String {
        translatedText ?? creation.text
    }

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
                    Text("Creation")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()

                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.clear)
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)

                Text(creation.type.rawValue)
                    .foregroundColor(.white)

                Text(creation.dateString)
                    .foregroundColor(.white.opacity(0.7))

                if !creation.text.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            Text(displayedText)
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)

                            VStack(spacing: 8) {
                                Button(action: { showTranslatePicker = true }) {
                                    HStack(spacing: 6) {
                                        Text(creationCountries.first(where: { $0.0 == selectedTranslateCountry })?.1 ?? "🇺🇸")
                                            .font(.system(size: 16))
                                        Text(selectedTranslateCountry)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                            .background(Color.white.opacity(0.06))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    )
                                }
                                .buttonStyle(.plain)

                                Button(action: translateText) {
                                    HStack(spacing: 6) {
                                        if isTranslating {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(0.85)
                                        } else {
                                            Image(systemName: "globe")
                                                .font(.system(size: 14))
                                            Text("Translate")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.15))
                                    )
                                }
                                .buttonStyle(.plain)
                                .disabled(isTranslating)
                                .opacity(isTranslating ? 0.7 : 1)
                                .padding(.horizontal, 60)
                            }
                            .padding(.bottom, 80)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)

            if let path = creation.audioURL, FileManager.default.fileExists(atPath: path) {
                VStack {
                    Spacer()
                    Button(action: togglePlayback) {
                        HStack(spacing: 6) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 36))
                            Image("equalizador")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 30)
                        }
                        .foregroundColor(.orange)
                    }
                    .padding(.bottom, 200)
                }
            } else if !creation.text.isEmpty {
                VStack {
                    Spacer()
                    Button(action: toggleSpeak) {
                        HStack(spacing: 6) {
                            Image(systemName: isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 36))
                            Image("equalizador")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 30)
                        }
                        .foregroundColor(.orange)
                    }
                    .padding(.bottom, 200)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setupAudioPlayerIfNeeded()
        }
        .onDisappear {
            audioPlayer?.stop()
            isPlaying = false
            speechSynthesizer?.stopSpeaking(at: .immediate)
            isSpeaking = false
        }
        .alert("Translation failed", isPresented: $showTranslationAlert) {
            Button("OK", role: .cancel) {
                showTranslationAlert = false
                translationError = nil
            }
        } message: {
            Text(translationError ?? "Could not translate.")
        }
        .sheet(isPresented: $showTranslatePicker) {
            LanguagePickerSheet(
                countries: creationCountries,
                selectedCountry: $selectedTranslateCountry,
                onDismiss: { showTranslatePicker = false }
            )
        }
    }

    private func translateText() {
        guard !creation.text.isEmpty else { return }
        isTranslating = true
        translatedText = nil
        GroqTranslationService.shared.translate(text: creation.text, toLanguage: selectedTranslateCountry) { result in
            isTranslating = false
            switch result {
            case .success(let text):
                translatedText = text
            case .failure(let error):
                translationError = error.localizedDescription
                showTranslationAlert = true
            }
        }
    }

    private func toggleSpeak() {
        if isSpeaking {
            speechSynthesizer?.stopSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            let delegate = SpeechDelegate()
            delegate.onDidFinish = { isSpeaking = false }
            let synth = AVSpeechSynthesizer()
            synth.delegate = delegate
            speechDelegate = delegate
            speechSynthesizer = synth
            let utterance = AVSpeechUtterance(string: displayedText)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.voice = AVSpeechSynthesisVoice(language: languageCode(for: translatedText != nil ? selectedTranslateCountry : creation.country))
            synth.speak(utterance)
            isSpeaking = true
        }
    }

    private func languageCode(for country: String) -> String {
        switch country.lowercased() {
        case "usa", "uk": return "en-US"
        case "germany": return "de-DE"
        case "france": return "fr-FR"
        case "spain": return "es-ES"
        case "italy": return "it-IT"
        default: return "en-US"
        }
    }

    private func setupAudioPlayerIfNeeded() {
        guard let path = creation.audioURL,
              FileManager.default.fileExists(atPath: path),
              audioPlayer == nil else { return }
        let url = URL(fileURLWithPath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            let player = try AVAudioPlayer(contentsOf: url)
            let delegate = AudioPlaybackDelegate()
            delegate.onDidFinish = { isPlaying = false }
            player.delegate = delegate
            player.prepareToPlay()
            audioPlayer = player
            playbackDelegate = delegate
        } catch {
            // Play button won't show if path invalid or player fails
        }
    }

    private func togglePlayback() {
        guard let player = audioPlayer else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
}

