import SwiftUI

struct CustomBottomBar: View {
    @Binding var selected: MainTab
    
    var body: some View {
        if selected == .home {
            ZStack {
                Image("barBack1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 285, height: 65)
                HStack {
                    TabButtonCreate(icon: "create", title: nil, isSelected: selected == .create) {
                        selected = .create
                    }
                    .padding(.leading, 56)
                    Spacer()
                    TabButtonChosen(icon: "homeC", title: "Home", isSelected: selected == .home) {
                        selected = .home
                    }
                    .padding(.leading, 5)
                    Spacer()
                    TabButton(icon: "creations", title: "Creations", isSelected: selected == .creations) {
                        selected = .creations
                    }
                    .padding(.trailing, 66)
                }
            }
        }
        
        if selected == .creations {
            ZStack {
                Image("barBack1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 285, height: 65)
                HStack {
                    TabButtonCreate(icon: "create", title: nil, isSelected: selected == .create) {
                        selected = .create
                    }
                    .padding(.leading, 56)
                    Spacer()
                    TabButton(icon: "home", title: "Home", isSelected: selected == .home) {
                        selected = .home
                    }
                    .padding(.leading, 5)
                    Spacer()
                    TabButtonChosen(icon: "creationsC", title: "Creations", isSelected: selected == .creations) {
                        selected = .creations
                    }
                    .padding(.trailing, 66)
                }
            }
        }
        
        if selected == .create {
            ZStack {
                Image("barBack2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 230, height: 65)
                HStack {
                    TabButtonCreate(icon: "createC", title: nil, isSelected: selected == .create) {
                        selected = .create
                    }
                    .padding(.leading, 82)
                    Spacer()
                    TabButton(icon: "home", title: "Home", isSelected: selected == .home) {
                        selected = .home
                    }
                    .padding(.leading, 5)
                    Spacer()
                    TabButton(icon: "creations", title: "Creations", isSelected: selected == .creations) {
                        selected = .creations
                    }
                    .padding(.trailing, 86)
                }
            }
        }
    }
}


struct TabButton: View {
    let icon: String
    let title: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

struct TabButtonChosen: View {
    let icon: String
    let title: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            ZStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 50)
            }
        }
    }
}

struct TabButtonCreate: View {
    let icon: String
    let title: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

