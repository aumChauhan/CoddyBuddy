import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var exploreFetchDataObject = ExploreSection_ViewModel()
    @ObservedObject var Obj_FetchUserQueriesOn_HomeTab_ViewModel = FetchUserQueriesOn_HomeTab_ViewModel()
    @State var search_textfield: String = ""
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @State var toogleActionSheetForLogOut: Bool = false
    @AppStorage("togglePromotion") var togglePromotion: Bool = true
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    SearchFieldView(search_textfield: $exploreFetchDataObject.search_textfield)
                    if !exploreFetchDataObject.search_textfield.isEmpty {
                        VStack {
                            ForEach(exploreFetchDataObject.filteredUser) { index in
                                NavigationLink {
                                    AllUserProfileView(userInfo: index)
                                } label: {
                                    UserNameAndID_SignleRow(userDataExploreRow: index)
                                }
                                Divider()
                            }
                        }
                    }
                    else {
                        TrendingView()
                    }
                }
                
                .navigationTitle("Explore")
                .navigationBarItems(
                    trailing:
                        Menu(content: {
                            Button {
                                Obj_FetchUserQueriesOn_HomeTab_ViewModel.fetchUserQuieries()
                                if toggleHaptics {
                                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                                }
                            } label: {
                                HStack {
                                    Text("Reload")
                                    
                                    Spacer()
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .foregroundColor(.red)
                                }
                            }
                            Button {
                                withAnimation {
                                    togglePromotion.toggle()
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(togglePromotion ? "Hide Recommendation" : "Show Recommendation" )
                                    Spacer()
                                    Image(systemName: togglePromotion ? "hand.raised.slash.fill" :  "hand.raised.fill")
                                }
                            }
                            Button(role: .destructive) {
                                toogleActionSheetForLogOut.toggle()
                                if toggleHaptics {
                                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                }
                            } label: {
                                HStack {
                                    Text("Log Out")
                                        .foregroundColor(.red)
                                    Spacer()
                                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }, label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(Color(selectedColor))
                        }
                            )
                )
            }
            .refreshable {
                Obj_FetchUserQueriesOn_HomeTab_ViewModel.fetchUserQuieries()
            }
            
            .confirmationDialog("Log Out", isPresented: $toogleActionSheetForLogOut, actions: {
                Button(role: .destructive) {
                    withAnimation {
                        AuthenticationObject.logOut()
                        selectedColor = "Theme_Blue"
                        if toggleHaptics {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                    }
                } label: {
                    Text("Log Out")
                }
                
                Button("Cancel", role: .cancel) {
                    if toggleHaptics {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                }
            })
            
            .navigationViewStyle(StackNavigationViewStyle())
            
        }.navigationViewStyle(.stack)
    }
    
    struct UserNameAndID_SignleRow: View {
        
        let userDataExploreRow: RegisteredUserDataModel?
        @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
        
        var body: some View {
            HStack(spacing: 12){
                OnlyProfilePhotoView(url: userDataExploreRow?.profilePicURL ?? "", key: userDataExploreRow?.id ?? "")
                
                VStack(alignment: .leading, spacing: 1){
                    HStack(alignment: .center, spacing: 3){
                        Text("\(userDataExploreRow?.anonymousName ?? false ? "Anonymous": userDataExploreRow?.fullName ?? "")")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Image(systemName: userDataExploreRow?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                            .foregroundColor(.teal)
                            .font(.caption)
                    }
                    Text("@\(userDataExploreRow?.anonymousUserName ?? false ? userDataExploreRow?.userName ?? "" : userDataExploreRow?.userName ?? "")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(2)
            .padding(.horizontal,12)
        }
    }
    
    struct SearchFieldView: View {
        
        @Binding var search_textfield: String
        @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
        @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
        
        
        var body: some View {
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray.opacity(0.4))
                
                TextField("Find Users", text: $search_textfield)
                    .tint(Color(selectedColor))
                Spacer()
                
                if search_textfield.count >= 1 {
                    Button {
                        search_textfield = ""
                        if toggleHaptics {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.4))
                    }
                }
                
            }
            .padding(8)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}
