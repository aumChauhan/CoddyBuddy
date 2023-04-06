import SwiftUI
import FirebaseCore

@main
struct CoddyBuddyApp: App {
    @StateObject var AuthenticationObject = UserAuthnticateViewModel()
    @AppStorage("systemThemMode") var systemThemMode: Int = (themeCases.allCases.first?.rawValue ?? 1)
       
       var selectedTheme: ColorScheme? {
           guard let theme = themeCases(rawValue: systemThemMode) else { return nil }
           switch theme {
           case .light:
               return .light
           case .dark:
               return .dark
           default:
               return nil
           }
       }

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
                SplashScreenView()
                    .environmentObject(AuthenticationObject)
                    .preferredColorScheme(selectedTheme)
        }
    }
}
