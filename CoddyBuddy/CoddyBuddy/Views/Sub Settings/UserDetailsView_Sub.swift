import SwiftUI

struct UserDetailsView_Sub: View {
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @State var toogleEditDone: Bool = false
    @State var Name: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 30, height: 4)
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(6)
                Spacer()
            }
            VStack {
                ZStack {
                    VStack {
                        Section {
                            VStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(colors: [Color("CB_Light"), Color("CB_Dark")], startPoint: .top, endPoint: .bottom))
                                    .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height/4, alignment: .center)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 13)
                                            .strokeBorder(.white, lineWidth: 1.5)
                                            .frame(width: UIScreen.main.bounds.width/1.15, height: UIScreen.main.bounds.height/4.34, alignment: .center)
                                            .foregroundColor(.white.opacity(0))
                                            .overlay{
                                                Image("ArrayPNG")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .mask {
                                                        RoundedRectangle(cornerRadius: 14)
                                                            .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.height/4.5, alignment: .center)
                                                    }
                                                    .scaledToFill()
                                                
                                            }
                                    }
                                    .overlay {
                                        VStack {
                                            HStack(alignment: .center, spacing:2) {
                                                Image("Smily Braces")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                Spacer()
                                            }
                                            Spacer()
                                            
                                            HStack {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 3) {
                                                        Text("\(AuthenticationObject.currentUserData?.fullName.capitalized ?? "")")
                                                            .font(.title3)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.white)
                                                        
                                                        Image(systemName: AuthenticationObject.currentUserData?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                                            .foregroundColor(.white)
                                                            .font(.caption)
                                                    }
                                                    HStack(spacing:3) {
                                                        Text("\(AuthenticationObject.currentUserData?.userName ?? "")")
                                                            .font(.caption)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                Spacer()
                                                
                                                
                                            }
                                        }
                                        .padding(14)
                                        .frame(width: UIScreen.main.bounds.width/1.15, height: UIScreen.main.bounds.height/4.34, alignment: .center)
                                    }
                                
                            }
                        }
                        .shadow(color: .blue.opacity(0.5), radius: 4)
                        
                        List {
                            Section("User Details") {
                                HStack(alignment: .center) {
                                    Text("Full Name")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text("\(AuthenticationObject.currentUserData?.fullName ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                HStack(alignment: .center) {
                                    Text("User Name")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text("\(AuthenticationObject.currentUserData?.userName ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                HStack(alignment: .center) {
                                    Text("Email")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text("\(AuthenticationObject.currentUserData?.email ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                }
                                HStack(alignment: .center) {
                                    Text("Joined CoddyBuddy")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text(AuthenticationObject.currentUserData?.joinedOn.dateValue().formatted(date: .numeric, time: .omitted) ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                }
                            }
                            
                            Section("Device Details") {
                                HStack(alignment: .center) {
                                    Text("Device Name")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text(UIDevice.current.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                HStack(alignment: .center) {
                                    Text("Model")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text(UIDevice.current.model)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                HStack(alignment: .center) {
                                    Text("System Name")
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    Text(UIDevice.current.systemName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                HStack(alignment: .center) {
                                    Text("System Version")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    Text(UIDevice.current.systemVersion)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                    
                }
            }
            .navigationTitle("Credentials")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .secondarySystemBackground).opacity(0))
    }
    
    
}

struct UserDetailsView_STACK: View {
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @State var toogleEditDone: Bool = false
    @State var Name: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            List {
                Section("User Details") {
                    HStack(alignment: .center) {
                        Text("Full Name")
                            .font(.subheadline)
                        
                        Spacer()
                        Text("\(AuthenticationObject.currentUserData?.fullName ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center) {
                        Text("User Name")
                            .font(.subheadline)
                        
                        Spacer()
                        Text("\(AuthenticationObject.currentUserData?.userName ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center) {
                        Text("Email")
                            .font(.subheadline)
                        
                        Spacer()
                        Text("\(AuthenticationObject.currentUserData?.email ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                }
                
                Section("Device Details") {
                    HStack(alignment: .center) {
                        Text("Device Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        Text(UIDevice.current.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center) {
                        Text("Model")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        Text(UIDevice.current.model)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center) {
                        Text("System Name")
                            .font(.subheadline)
                        
                        Spacer()
                        Text(UIDevice.current.systemName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center) {
                        Text("System Version")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        Text(UIDevice.current.systemVersion)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            .navigationTitle("Credentials")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .secondarySystemBackground).opacity(0))
    }
    
    
}

struct UserDetailsView_Sub_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView_Sub()
    }
}
