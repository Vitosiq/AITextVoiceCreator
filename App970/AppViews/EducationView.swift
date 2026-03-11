//import SwiftUI
//
//enum EducationTab {
//    case editor, gallery, dictionary
//}
//
//struct EducationView: View {
//    @Binding var hideTabBar: Bool
//    @State private var selectedTab: EducationTab = .editor
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Image("mainBackground")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                VStack {
//                    HStack {
//                        NavigationLink {
//                            SettingsView(hideTabBar: $hideTabBar)
//                        } label: {
//                            Image("settings")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                        }
//                        Spacer()
//                        Text("Education")
//                            .font(.title)
//                            .foregroundColor(.white)
//
//                        Spacer()
//                        NavigationLink {
//                            InboxView()
//                        } label: {
//                            Image("envelope")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding()
//                    .padding(.top, 50)
//                    
//                    CustomEducationBar(selected: $selectedTab)
//                        .padding(.horizontal, 6)
//                        .padding(.bottom, 16)
//                    
//                    Group {
//                        switch selectedTab {
//                        case .editor:
//                            ZStack {
//                                Image("educationEFrame")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 330, height: 500)
//                                VStack {
//                                    Image("eFrameOne")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 300, height: 90)
//                                    Image("eFrameTwo")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 300, height: 90)
//                                    .padding(.top, 10)
//                                    Image("eFrameThree")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 300, height: 90)
//                                    .padding(.top, 10)
//                                    NavigationLink {
//                                        EditorView(hideTabBar: $hideTabBar)
//                                    } label: {
//                                        Image("moreInfo")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 170, height: 40)
//                                    }
//                                }
//                                .padding(.top, 80)
//                            }
// 
//                        case .gallery:
//                            ZStack {
//                                Image("educationG")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 330, height: 500)
//                                VStack {
//                                    HStack {
//                                        Image("brasil")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 140, height: 140)
//                                        Image("cuba")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 140, height: 140)
//                                    }
//                                    HStack {
//                                        Image("france")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 140, height: 140)
//                                        Image("germany")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 140, height: 140)
//                                    }
//                                    NavigationLink {
//                                        GalleryView(hideTabBar: $hideTabBar)
//                                    } label: {
//                                        Image("moreInfo")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 170, height: 40)
//                                    }
//                                    
//                                }
//                                .padding(.top, 40)
//                            }
//
//                        case .dictionary:
//                            ZStack {
//                                Image("backFrame")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 330, height: 500)
//                                VStack {
//                                    Image("top")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 270, height: 100)
//
//                                    Image("bottom")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 270, height: 100)
//                                    
//                                    NavigationLink {
//                                        DictionaryView(hideTabBar: $hideTabBar)
//                                    } label: {
//                                        Image("moreInfo")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 170, height: 40)
//                                    }
//                                }
//                            }
//
//                        }
//                    }
//
//                    Spacer()
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//}
//
//struct CustomEducationBar: View {
//    @Binding var selected: EducationTab
//    
//    var body: some View {
//        if selected == .editor {
//            HStack {
//                EducationButton(icon: "editorC", isSelected: selected == .editor) {
//                    selected = .editor
//                }
//                Spacer()
//                EducationButton(icon: "gallery", isSelected: selected == .gallery) {
//                    selected = .gallery
//                }
//                Spacer()
//                EducationButton(icon: "dictionary", isSelected: selected == .dictionary) {
//                    selected = .dictionary
//                }
//            }
//            .padding(.horizontal)
//            .padding(.horizontal)
//        }
//        if selected == .gallery {
//            HStack {
//                EducationButton(icon: "editor", isSelected: selected == .editor) {
//                    selected = .editor
//                }
//                Spacer()
//                EducationButton(icon: "galleryC", isSelected: selected == .gallery) {
//                    selected = .gallery
//                }
//                Spacer()
//                EducationButton(icon: "dictionary", isSelected: selected == .dictionary) {
//                    selected = .dictionary
//                }
//            }
//            .padding(.horizontal)
//            .padding(.horizontal)
//        }
//        if selected == .dictionary {
//            HStack {
//                EducationButton(icon: "editor", isSelected: selected == .editor) {
//                    selected = .editor
//                }
//                Spacer()
//                EducationButton(icon: "gallery", isSelected: selected == .gallery) {
//                    selected = .gallery
//                }
//                Spacer()
//                EducationButton(icon: "dictionaryC", isSelected: selected == .dictionary) {
//                    selected = .dictionary
//                }
//            }
//            .padding(.horizontal)
//            .padding(.horizontal)
//            
//        }
//        
//    }
//}
//
//struct EducationButton: View {
//    let icon: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        
//        Button(action: action) {
//            Image(icon)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 105, height: 40)
//        }
//    }
//}
//
//struct EditorView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var hideTabBar: Bool
//
//    @State private var notificationsOn = true
//
//    var body: some View {
//        ZStack {
//            Image("editorB")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//
//            VStack(spacing: 25) {
//                HStack {
//                    Button {
//                        hideTabBar = false
//                        dismiss()
//                    } label: {
//                        Image("back")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//
//                    Spacer()
//                }
//                .padding(.top, 60)
//                .padding(.horizontal)
//
//                Spacer()
//            }
//            .padding(.horizontal)
//        }
//        .onAppear { hideTabBar = true }
//        .onDisappear { hideTabBar = false }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct GalleryView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var hideTabBar: Bool
//
//    @State private var notificationsOn = true
//
//    var body: some View {
//        ZStack {
//            Image("galleryB")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//
//            VStack(spacing: 25) {
//                HStack {
//                    Button {
//                        hideTabBar = false
//                        dismiss()
//                    } label: {
//                        Image("back")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//
//                    Spacer()
//                }
//                .padding(.top, 60)
//                .padding(.horizontal)
//
//                Spacer()
//            }
//            .padding(.horizontal)
//        }
//        .onAppear { hideTabBar = true }
//        .onDisappear { hideTabBar = false }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct DictionaryView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var hideTabBar: Bool
//
//    @State private var notificationsOn = true
//
//    var body: some View {
//        ZStack {
//            Image("dictionaryB")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//
//            VStack(spacing: 25) {
//                HStack {
//                    Button {
//                        hideTabBar = false
//                        dismiss()
//                    } label: {
//                        Image("back")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//
//                    Spacer()
//                }
//                .padding(.top, 60)
//                .padding(.horizontal)
//
//                Spacer()
//            }
//            .padding(.horizontal)
//        }
//        .onAppear { hideTabBar = true }
//        .onDisappear { hideTabBar = false }
//        .navigationBarBackButtonHidden(true)
//    }
//}
