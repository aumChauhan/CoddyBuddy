import SwiftUI

struct AppiconSetting_View: View {
    @State var frameWH: CGFloat = 40
    @State var frameRadius: CGFloat = 12
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("selectedAppIcon") var selectedAppIcon: String = "AppIcon"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @State var isSelected: Bool = false
    @State var actionSheetToogle: Bool = false
    
    let iconArrayPack: [String] = [
        "AppIcon 1",  "AppIcon 2",  "AppIcon 3",  "AppIcon 4",  "AppIcon 5",
        "AppIcon 6"
    ]
    
    let ColorThemeArray: [String] = [
        "Theme_Blue", "Theme_Purple", "Theme_Pink","Theme_Orange","Theme_Graphite","Theme_Green","Theme_Red", "Theme_Indigo", "Theme_Brown"
    ]
    
    var body: some View {
        List {
            Section("Color Palette") {
                HStack {
                    Text("Current Theme")
                    Spacer()
                    
                    Text(selectedColor)
                        .foregroundColor(.gray)
                }
                .padding(7)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 13) {
                        ForEach(ColorThemeArray, id: \.self) { index in
                            Button {
                                selectedColor = index
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 40)
                                    .frame(width: frameWH, height: frameWH)
                                    .foregroundColor(Color(index))
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
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Themes")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    actionSheetToogle.toggle()
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                }, label: {
                    Text("Reset")
                        .foregroundColor(Color(selectedColor))
                })
        )
        
        .confirmationDialog(Text("Reset"), isPresented: $actionSheetToogle, titleVisibility: .hidden) {
            Button("Reset Theme") {
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
            Button("Reset All Theme Preferences") {
                selectedColor = "Theme_Blue"
                UIApplication.shared.setAlternateIconName("AppIcon 1")
                if toggleHaptics {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                
            }
        }.tint(Color(selectedColor))
    }
}

struct AppiconSetting_View_Previews: PreviewProvider {
    static var previews: some View {
        AppiconSetting_View()
    }
}
