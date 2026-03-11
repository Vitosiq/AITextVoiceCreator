import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @EnvironmentObject var creationsManager: CreationsManager
    @State private var showDeleteAlert = false
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
                        hideTabBar = false
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    Text("Settings")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.clear)
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                VStack(spacing: 35) {
                    SettingToggleRow(
                        title: "Notification",
                        isOn: $notificationsOn
                    )
                    
                    SettingButtonRow(
                        title: "How to use",
                        iconName: "info.circle",
                        action: openGoogle
                    ).padding(.top, 5)
                    
                    SettingButtonRow(
                        title: "Rate us",
                        iconName: "square.and.arrow.up",
                        action: openAppStore
                    )
                    
                    SettingDestructiveButtonRow(
                        title: "Delete Data",
                        iconName: "trash",
                        action: {
                            showDeleteAlert = true
                        }
                    )
                }.padding(.top, 10)

                
                Spacer()
                
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarBackButtonHidden(true)
        .alert("Delete All Data?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                creationsManager.deleteAll()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all your creations? This action cannot be undone.")
        }
    }
}

func openGoogle() {
    if let url = URL(string: "https://www.google.com") {
        UIApplication.shared.open(url)
    }
}

func openAppStore() {
    if let url = URL(string: "https://apps.apple.com") {
        UIApplication.shared.open(url)
    }
}

func deleteData() {
    print("Data deleted")
}

struct SettingButtonRow: View {
    let title: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.horizontal)
            .background(
                Image("settingButton")
                    .resizable()
                    .frame(width: 360, height: 60)
            )
        }
    }
}

struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.white.opacity(0.3)))
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .padding(.horizontal)
        .background(
            Image("settingButton")
                .resizable()
                .frame(width: 360, height: 60)
        )
    }
}

struct SettingDestructiveButtonRow: View {
    let title: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.horizontal)
            .background(
                Image("settingButtonDelete")
                    .resizable()
                    .frame(width: 360, height: 60)
            )
        }
    }
}


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
