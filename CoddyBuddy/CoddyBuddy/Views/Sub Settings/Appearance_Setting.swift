import SwiftUI

struct Appearance_Setting: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("chatBotIcon") var chatBotIcon: String = "bot"
    @AppStorage("systemThemMode") var systemThemMode: Int = (themeCases.allCases.first?.rawValue ?? 1)
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("togglePromotion") var togglePromotion: Bool = true
    @AppStorage("playSoundOnCopied") var playSoundOnCopied: Bool = true
    @AppStorage("toggleLocalNotifications") var toggleLocalNotifications: Bool = true
    @State var frameWH: CGFloat = 40
    @State var frameRadius: CGFloat = 12
    @State var actionSheetToogle: Bool = false
    @AppStorage("selectedAppIcon") var selectedAppIcon: String = "AppIcon"
    @State var isSelected: Bool = false
    
    let iconArrayPack: [String] = [
        "AppIcon 1",  "AppIcon 2",  "AppIcon 3",  "AppIcon 4","AppIcon 5",
    ]
    
    let ColorThemeArray: [String] = [
        "Theme_Blue", "Theme_Purple", "Theme_Pink","Theme_Orange","Theme_Graphite","Theme_Green","Theme_Red", "Theme_Indigo", "Theme_Brown"
    ]
    
    var selectedTheme: ColorScheme? {
        guard let theme = themeCases(rawValue: systemThemMode) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .none
        default:
            return nil
        }
    }
    
    var body: some View {
        List {
            Section("Color Palette") {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 13) {
                        ForEach(ColorThemeArray, id: \.self) { index in
                            Button {
                                selectedColor = index
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            } label: {
                                VStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .frame(width: frameWH, height: frameWH)
                                        .foregroundColor(Color(index))
                                        .overlay {
                                            if selectedColor == index {
                                                Image(systemName: "checkmark")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                }
                            }
                        }
                        if colorScheme == .light {
                            Button {
                                selectedColor = "Theme_Primary"
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 40)
                                    .frame(width: frameWH, height: frameWH)
                                    .foregroundColor(Color("Theme_Primary"))
                            }
                        }
                    }.padding(5)
                }
            }
            
            Section("APP ICONS"){
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing:15) {
                        ForEach(iconArrayPack, id: \.self) { Index in
                            Button {
                                UIApplication.shared.setAlternateIconName(Index)
                                isSelected.toggle()
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            } label: {
                                Image("C\(Index)")
                                    .resizable()
                                    .frame(width: 55, height: 55 )
                                    .mask(
                                        RoundedRectangle(cornerRadius: 13)
                                            .frame(width: 55, height: 55)
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            
            Section("App Appearance") {
                Picker("Appearance", selection: $systemThemMode) {
                    ForEach(themeCases.allCases) { index in
                        Text(index.title)
                            .tag(index.rawValue)
                    }
                }
                
                VStack {
                    withAnimation {
                        Toggle("ChatBot", isOn: $toggleChatBot)
                            .tint(Color(selectedColor))
                    }
                }
                
                Picker("ChatBot Icon", selection: $chatBotIcon) {
                    Image("bot")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tag("bot")
                    
                    Image("bot2")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tag("bot2")
                }
                .pickerStyle(.navigationLink)
                
            }
            
            Section {
                Toggle("Haptics", isOn: $toggleHaptics)
                    .tint(Color(selectedColor))
                
                Toggle("Recommendation", isOn: $togglePromotion)
                    .tint(Color(selectedColor))
                
                Toggle("Play Sound While Copying", isOn: $playSoundOnCopied)
                    .tint(Color(selectedColor))
            }
        }
        .preferredColorScheme(selectedTheme)
        .listStyle(.insetGrouped)
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    actionSheetToogle.toggle()
                }, label: {
                    Text("Reset")
                        .foregroundColor(Color(selectedColor))
                })
        )
        
        .confirmationDialog(Text("Reset"), isPresented: $actionSheetToogle, titleVisibility: .hidden) {
            Button("Reset Color Palette") {
                selectedColor = "Theme_Blue"
                if toggleHaptics {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
            Button("Reset App Icon") {
                UIApplication.shared.setAlternateIconName("AppIcon 1")
                if toggleHaptics {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
            Button("Reset All Preferences") {
                selectedColor = "Theme_Blue"
                UIApplication.shared.setAlternateIconName("AppIcon 1")
                if toggleHaptics {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                systemThemMode = 3
                toggleChatBot = true
                toggleHaptics = true
                togglePromotion = true
                
            }
        }
        .tint(Color(selectedColor))
    }
}

struct Appearance_Setting_Previews : PreviewProvider {
    static var previews: some View {
        Appearance_Setting()
    }
}
