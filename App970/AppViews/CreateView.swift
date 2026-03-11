import SwiftUI

enum Field: Hashable {
    case name
    case text
}

struct CreateView: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                ScrollView {
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
                            Text("Create")
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
                        
                        VStack {
                            HStack {
                                NavigationLink {
                                    ScreamerView(hideTabBar: $hideTabBar)
                                } label: {
                                    Image("screamer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 210)
                                }
                                
                                NavigationLink {
                                    SpeechView(hideTabBar: $hideTabBar)
                                } label: {
                                    Image("speech")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 210)
                                }
                            }
                            
                            HStack {
                                NavigationLink {
                                    SloganView(hideTabBar: $hideTabBar)
                                } label: {
                                    Image("slogan")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 210)
                                }
                                
                                NavigationLink {
                                    SongView(hideTabBar: $hideTabBar)
                                } label: {
                                    Image("song")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 210)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ScreamerView: View {
    @Binding var hideTabBar: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var creationsManager: CreationsManager
    @EnvironmentObject var creationGenerator: CreationGenerator
    @FocusState private var focusedField: Field?
    @State private var name: String = ""
    @State private var text: String = ""
    @State private var selectedCountry: String = "USA"
    @State private var selectedStyle: AIStyle = .patriotic
    @State private var showStylePicker: Bool = false
    @State private var showCountryPicker: Bool = false
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    let countries = [
        ("USA", "🇺🇸"),
        ("UK", "🇬🇧"),
        ("Germany", "🇩🇪"),
        ("France", "🇫🇷"),
        ("Spain", "🇪🇸"),
        ("Italy", "🇮🇹")
    ]
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        Text("Create")
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
                    .padding(.top, 50)
                    
                    Text("Step 1 - Type")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 15) {
                        TypeButton(title: "Speech", isSelected: false)
                        TypeButton(title: "Slogan", isSelected: false)
                        TypeButton(title: "Song", isSelected: false)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Screamer")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.05, green: 0.08, blue: 0.25))
                            .clipShape(Capsule())
                        
                        Text("Screamer - Stadium Energy!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Create powerful, rhythmic screams that ignite the stands.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Text("Step 2 - Text")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 30)
                    
                    HStack {
                        TextField("Name", text: $name)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .name)
                            .placeholder(when: name.isEmpty) {
                                Text("Name").foregroundColor(.white.opacity(0.5))
                            }
                            .padding(10)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: { showCountryPicker.toggle() }) {
                            HStack {
                                Text(countries.first(where: { $0.0 == selectedCountry })?.1 ?? "🇺🇸")
                                    .font(.system(size: 20))
                                Text(selectedCountry)
                                    .foregroundColor(.white)
                                Image(systemName: showCountryPicker ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if showCountryPicker {
                        VStack(spacing: 10) {
                            ForEach(countries, id: \.0) { country in
                                Button(action: {
                                    selectedCountry = country.0
                                    showCountryPicker = false
                                }) {
                                    HStack {
                                        Text(country.1)
                                            .font(.system(size: 24))
                                        Text(country.0)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCountry == country.0 ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    TextField("Enter text for Screamer", text: $text)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .text)
                        .placeholder(when: text.isEmpty) {
                            Text("Enter text for Screamer").foregroundColor(.white.opacity(0.5))
                        }
                        .padding(10)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        isGenerating = true
                        generateAndSaveCreation()
                    }) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Generate AI voice")
                                    .font(.system(size: 16, weight: .semibold))
                                Image(systemName: "waveform")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .disabled(name.isEmpty || text.isEmpty || isGenerating)
                    .opacity((name.isEmpty || text.isEmpty || isGenerating) ? 0.5 : 1)
                    
                    Button(action: { showStylePicker.toggle() }) {
                        HStack {
                            Text(selectedStyle.rawValue)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: showStylePicker ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                .background(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if showStylePicker {
                        VStack(spacing: 10) {
                            ForEach(AIStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    selectedStyle = style
                                    showStylePicker = false
                                }) {
                                    Text(style.rawValue)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedStyle == style ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Text("Enter all data to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 100)
                }
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            focusedField = nil
        }
        .alert("Generation failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                showErrorAlert = false
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Something went wrong. Add GroqAPIKey in Config.plist. Free key at console.groq.com")
        }
    }
    
    private func generateAndSaveCreation() {
        creationGenerator.generate(
            type: .screamer,
            name: name,
            text: text,
            country: selectedCountry,
            style: selectedStyle
        ) { result in
            isGenerating = false
            switch result {
            case .success(let creation):
                creationsManager.addCreation(creation)
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

struct SpeechView: View {
    @Binding var hideTabBar: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var creationsManager: CreationsManager
    @EnvironmentObject var creationGenerator: CreationGenerator
    @FocusState private var focusedField: Field?
    @State private var name: String = ""
    @State private var text: String = ""
    @State private var selectedCountry: String = "USA"
    @State private var selectedStyle: AIStyle = .patriotic
    @State private var showStylePicker: Bool = false
    @State private var showCountryPicker: Bool = false
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    let countries = [
        ("USA", "🇺🇸"),
        ("UK", "🇬🇧"),
        ("Germany", "🇩🇪"),
        ("France", "🇫🇷"),
        ("Spain", "🇪🇸"),
        ("Italy", "🇮🇹")
    ]
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        Text("Create")
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
                    .padding(.top, 50)
                    
                    Text("Step 1 - Type")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 15) {
                        TypeButton(title: "Screamer", isSelected: false)
                        TypeButton(title: "Slogan", isSelected: false)
                        TypeButton(title: "Song", isSelected: false)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Speech")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.05, green: 0.08, blue: 0.25))
                            .clipShape(Capsule())
                        
                        Text("Speech is short but to the point!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Short bright slogans that are memorable from the first time.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Text("Step 2 - Text")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 30)
                    
                    HStack {
                        TextField("Name", text: $name)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .name)
                            .placeholder(when: name.isEmpty) {
                                Text("Name").foregroundColor(.white.opacity(0.5))
                            }
                            .padding(10)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: { showCountryPicker.toggle() }) {
                            HStack {
                                Text(countries.first(where: { $0.0 == selectedCountry })?.1 ?? "🇺🇸")
                                    .font(.system(size: 20))
                                Text(selectedCountry)
                                    .foregroundColor(.white)
                                Image(systemName: showCountryPicker ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if showCountryPicker {
                        VStack(spacing: 10) {
                            ForEach(countries, id: \.0) { country in
                                Button(action: {
                                    selectedCountry = country.0
                                    showCountryPicker = false
                                }) {
                                    HStack {
                                        Text(country.1)
                                            .font(.system(size: 24))
                                        Text(country.0)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCountry == country.0 ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    TextField("Enter text for Speech", text: $text)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .text)
                        .placeholder(when: text.isEmpty) {
                            Text("Enter text for Speech")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(10)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        isGenerating = true
                        generateAndSaveCreation()
                    }) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Generate AI voice")
                                    .font(.system(size: 16, weight: .semibold))
                                Image(systemName: "waveform")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .disabled(name.isEmpty || text.isEmpty || isGenerating)
                    .opacity((name.isEmpty || text.isEmpty || isGenerating) ? 0.5 : 1)
                    
                    Button(action: { showStylePicker.toggle() }) {
                        HStack {
                            Text(selectedStyle.rawValue)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: showStylePicker ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                .background(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if showStylePicker {
                        VStack(spacing: 10) {
                            ForEach(AIStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    selectedStyle = style
                                    showStylePicker = false
                                }) {
                                    Text(style.rawValue)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedStyle == style ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Text("Enter all data to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 100)
                }
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            focusedField = nil
        }
        .alert("Generation failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                showErrorAlert = false
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Something went wrong. Add GroqAPIKey in Config.plist. Free key at console.groq.com")
        }
    }
    
    private func generateAndSaveCreation() {
        creationGenerator.generate(
            type: .speech,
            name: name,
            text: text,
            country: selectedCountry,
            style: selectedStyle
        ) { result in
            isGenerating = false
            switch result {
            case .success(let creation):
                creationsManager.addCreation(creation)
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

struct SloganView: View {
    @Binding var hideTabBar: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var creationsManager: CreationsManager
    @EnvironmentObject var creationGenerator: CreationGenerator
    @FocusState private var focusedField: Field?
    @State private var name: String = ""
    @State private var text: String = ""
    @State private var selectedCountry: String = "USA"
    @State private var selectedStyle: AIStyle = .patriotic
    @State private var showStylePicker: Bool = false
    @State private var showCountryPicker: Bool = false
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    let countries = [
        ("USA", "🇺🇸"),
        ("UK", "🇬🇧"),
        ("Germany", "🇩🇪"),
        ("France", "🇫🇷"),
        ("Spain", "🇪🇸"),
        ("Italy", "🇮🇹")
    ]
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        Text("Create")
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
                    .padding(.top, 50)
                    
                    Text("Step 1 - Type")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 15) {
                        TypeButton(title: "Screamer", isSelected: false)
                        TypeButton(title: "Speech", isSelected: false)
                        TypeButton(title: "Song", isSelected: false)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Slogan")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.05, green: 0.08, blue: 0.25))
                            .clipShape(Capsule())
                        
                        Text("Slogan - Champion's Speech!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Inspirational or provocative speeches.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Text("Step 2 - Text")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 30)
                    
                    HStack {
                        TextField("Name", text: $name)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .name)
                            .placeholder(when: name.isEmpty) {
                                Text("Name").foregroundColor(.white.opacity(0.5))
                            }
                            .padding(10)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: { showCountryPicker.toggle() }) {
                            HStack {
                                Text(countries.first(where: { $0.0 == selectedCountry })?.1 ?? "🇺🇸")
                                    .font(.system(size: 20))
                                Text(selectedCountry)
                                    .foregroundColor(.white)
                                Image(systemName: showCountryPicker ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if showCountryPicker {
                        VStack(spacing: 10) {
                            ForEach(countries, id: \.0) { country in
                                Button(action: {
                                    selectedCountry = country.0
                                    showCountryPicker = false
                                }) {
                                    HStack {
                                        Text(country.1)
                                            .font(.system(size: 24))
                                        Text(country.0)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCountry == country.0 ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    TextField("Enter text for Slogan", text: $text)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .text)
                        .placeholder(when: text.isEmpty) {
                            Text("Enter text for Slogan")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(10)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    
                    Button(action: {
                        isGenerating = true
                        generateAndSaveCreation()
                    }) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Generate AI voice")
                                    .font(.system(size: 16, weight: .semibold))
                                Image(systemName: "waveform")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .disabled(name.isEmpty || text.isEmpty || isGenerating)
                    .opacity((name.isEmpty || text.isEmpty || isGenerating) ? 0.5 : 1)
                    
                    Button(action: { showStylePicker.toggle() }) {
                        HStack {
                            Text(selectedStyle.rawValue)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: showStylePicker ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                .background(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if showStylePicker {
                        VStack(spacing: 10) {
                            ForEach(AIStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    selectedStyle = style
                                    showStylePicker = false
                                }) {
                                    Text(style.rawValue)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedStyle == style ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Text("Enter all data to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 100)
                }
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            focusedField = nil
        }
        .alert("Generation failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                showErrorAlert = false
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Something went wrong. Add GroqAPIKey in Config.plist. Free key at console.groq.com")
        }
    }
    
    private func generateAndSaveCreation() {
        creationGenerator.generate(
            type: .slogan,
            name: name,
            text: text,
            country: selectedCountry,
            style: selectedStyle
        ) { result in
            isGenerating = false
            switch result {
            case .success(let creation):
                creationsManager.addCreation(creation)
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

struct SongView: View {
    @Binding var hideTabBar: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var creationsManager: CreationsManager
    @EnvironmentObject var creationGenerator: CreationGenerator
    @FocusState private var focusedField: Field?
    @State private var name: String = ""
    @State private var text: String = ""
    @State private var selectedCountry: String = "USA"
    @State private var selectedStyle: AIStyle = .patriotic
    @State private var showStylePicker: Bool = false
    @State private var showCountryPicker: Bool = false
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    let countries = [
        ("USA", "🇺🇸"),
        ("UK", "🇬🇧"),
        ("Germany", "🇩🇪"),
        ("France", "🇫🇷"),
        ("Spain", "🇪🇸"),
        ("Italy", "🇮🇹")
    ]
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        Text("Create")
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
                    .padding(.top, 50)
                    
                    Text("Step 1 - Type")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    HStack(spacing: 15) {
                        TypeButton(title: "Screamer", isSelected: false)
                        TypeButton(title: "Speech", isSelected: false)
                        TypeButton(title: "Slogan", isSelected: false)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Song")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.05, green: 0.08, blue: 0.25))
                            .clipShape(Capsule())
                        
                        Text("The song is your team's anthem!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Full-fledged backing songs with verses and chorus.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Text("Step 2 - Text")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 30)
                    
                    HStack {
                        TextField("Name Song", text: $name)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: .name)
                            .placeholder(when: name.isEmpty) {
                                Text("Name Song").foregroundColor(.white.opacity(0.5))
                            }
                            .padding(10)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: { showCountryPicker.toggle() }) {
                            HStack {
                                Text(countries.first(where: { $0.0 == selectedCountry })?.1 ?? "🇺🇸")
                                    .font(.system(size: 20))
                                Text(selectedCountry)
                                    .foregroundColor(.white)
                                Image(systemName: showCountryPicker ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if showCountryPicker {
                        VStack(spacing: 10) {
                            ForEach(countries, id: \.0) { country in
                                Button(action: {
                                    selectedCountry = country.0
                                    showCountryPicker = false
                                }) {
                                    HStack {
                                        Text(country.1)
                                            .font(.system(size: 24))
                                        Text(country.0)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCountry == country.0 ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    TextField("Enter text for Song", text: $text)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .text)
                        .placeholder(when: text.isEmpty) {
                            Text("Enter text for Song")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(10)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    
                    Button(action: {
                        isGenerating = true
                        generateAndSaveCreation()
                    }) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Generate AI voice")
                                    .font(.system(size: 16, weight: .semibold))
                                Image(systemName: "waveform")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .disabled(name.isEmpty || text.isEmpty || isGenerating)
                    .opacity((name.isEmpty || text.isEmpty || isGenerating) ? 0.5 : 1)
                    
                    Button(action: { showStylePicker.toggle() }) {
                        HStack {
                            Text(selectedStyle.rawValue)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: showStylePicker ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                .background(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if showStylePicker {
                        VStack(spacing: 10) {
                            ForEach(AIStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    selectedStyle = style
                                    showStylePicker = false
                                }) {
                                    Text(style.rawValue)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedStyle == style ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Text("Enter all data to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 100)
                }
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            focusedField = nil
        }
        .alert("Generation failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                showErrorAlert = false
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "Something went wrong. Add GroqAPIKey in Config.plist. Free key at console.groq.com")
        }
    }
    
    private func generateAndSaveCreation() {
        creationGenerator.generate(
            type: .song,
            name: name,
            text: text,
            country: selectedCountry,
            style: selectedStyle
        ) { result in
            isGenerating = false
            switch result {
            case .success(let creation):
                creationsManager.addCreation(creation)
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

struct TypeButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .stroke(isSelected ? Color.blue : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
                    .clipShape(Capsule())
            )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct TransparentTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}


