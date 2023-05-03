import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var switchTabCount: Int = 0
    @State var tabCategory: [String] = ["Likes", "Queries"]
    @State var tabSelected: String = "Likes"
    @Namespace private var namepsace
    @State var previewSheetToogle: Bool = false
    @ObservedObject var Object_ProfileViewModel: ProfileViewModel
    @State var reloadData: Bool = false
    @State var showProfilePhoto: Bool = false
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    init(userInfo: RegisteredUserDataModel) {
        self.Object_ProfileViewModel = ProfileViewModel(userInfo: userInfo)
    }
    
    var body: some View {
        NavigationView {
            if let loggedInUser = AuthenticationObject.currentUserData {
                ZStack(alignment: .center) {
                    ScrollView {
                        VStack(spacing : 0) {
                            VStack(spacing: 0) {
                                VStack {
                                    HStack(alignment: .top, spacing:3){
                                        OnlyProfilePhotoView(url: loggedInUser.profilePicURL, key: loggedInUser.id ?? "")
                                            .onTapGesture {
                                                withAnimation(Animation.spring()) {
                                                    showProfilePhoto.toggle()
                                                }
                                            }
                                        
                                        VStack(alignment: .leading, spacing: 0){
                                            HStack(alignment: .center,spacing: 3) {
                                                Text("\(loggedInUser.fullName)")
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                                
                                                Image(systemName:loggedInUser.isVerfied ? "checkmark.seal.fill" : "")
                                                    .foregroundColor(.teal)
                                                    .font(.caption)
                                            }
                                            
                                            Text("@\(loggedInUser.userName)")
                                                .font(.caption)
                                                .fontWeight(.light)
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                        .padding(.leading, 7)
                                        
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.init(uiColor: .secondarySystemBackground))
                                .cornerRadius(13)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 0)
                                .padding(.bottom, 9)
                                
                                HStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 7) {
                                            Text("Likes")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                            
                                            Text("\(Object_ProfileViewModel.userLikedPosts.count)")
                                                .font(.callout)
                                                .fontWeight(.medium)
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.init(uiColor: .secondarySystemBackground))
                                    .cornerRadius(13)
                                    .padding(.vertical, 0)
                                    .padding(.bottom, 9)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 7) {
                                            Text("Queries")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                            
                                            Text("\(Object_ProfileViewModel.userPosts.count)")
                                                .font(.callout)
                                                .fontWeight(.medium)
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.init(uiColor: .secondarySystemBackground))
                                    .cornerRadius(13)
                                    .padding(.vertical, 0)
                                    .padding(.bottom, 9)
                                    
                                }
                                .padding(.bottom, 2)
                                .padding(.horizontal, 15)
                                
                                VStack(alignment: .leading, spacing: 0){
                                    HStack {
                                        ForEach(tabCategory, id: \.self) { index in
                                            ZStack {
                                                if tabSelected == index {
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .foregroundColor(Color(selectedColor))
                                                        .matchedGeometryEffect(id: "Tabs", in: namepsace)
                                                }
                                                Text("       \(index)       ")
                                                    .fontWeight(tabSelected == index ? .medium : .regular)
                                                    .foregroundColor(tabSelected == index ? .white : .gray)
                                                    .onTapGesture {
                                                        withAnimation(.spring()) {
                                                            tabSelected = index
                                                        }
                                                    }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 35)
                                        }
                                    }
                                    .background(Color.init(.secondarySystemBackground))
                                    .cornerRadius(100)
                                    .padding(.bottom, 9)
                                }
                                .padding(.horizontal, 15)
                                
                                VStack {
                                    switch tabSelected {
                                    case "Likes":
                                        if Object_ProfileViewModel.userLikedPosts.count == 0 {
                                            VStack(spacing: 0){
                                                LottieAnimationViews(fileName: "119180-sad-rainy-folder")
                                                    .frame(width: 160, height: 160)
                                                Text("Nothing Liked Yet")
                                                    .font(.headline)
                                                    .foregroundColor(.primary.opacity(0.9))
                                                    .fontWeight(.bold)
                                                    .padding(.top, -10)
                                            }
                                            .padding(.top, 25)
                                        } else {
                                            likeProfileView
                                        }
                                    case "Queries":
                                        if Object_ProfileViewModel.userPosts.count == 0 {
                                            VStack(spacing: 0){
                                                LottieAnimationViews(fileName: "119180-sad-rainy-folder")
                                                    .frame(width: 160, height: 160)
                                                Text("Nothing Posted Yet")
                                                    .font(.headline)
                                                    .foregroundColor(.primary.opacity(0.9))
                                                    .fontWeight(.bold)
                                                    .padding(.top, -10)
                                            }
                                            .padding(.top, 25)
                                        } else {
                                            postsProfileView
                                        }
                                    default:
                                        likeProfileView
                                    }
                                }
                                Spacer()
                            }
                            
                        }
                    }
                    .refreshable {
                        Object_ProfileViewModel.fetchLikedQuestion()
                        Object_ProfileViewModel.fetchUserOwnPosts()
                    }
                    if showProfilePhoto {
                        VStack {
                            AsyncImage(url: URL(string: loggedInUser.profilePicURL), content: { image in
                                withAnimation {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                        .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width/1.5))
                                }
                            }, placeholder: {
                                withAnimation {
                                    RoundedRectangle(cornerRadius:UIScreen.main.bounds.width/1.5 )
                                        .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .overlay {
                                            LottieAnimationViews(fileName: "loadingImage")
                                                .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/1.5)
                                        }
                                }
                            })
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showProfilePhoto.toggle()
                        }
                        
                    }
                }
                .navigationTitle("Profile")
                .navigationBarItems(
                    trailing: Button(action: {
                        previewSheetToogle.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(showProfilePhoto ? .white.opacity(0.0) : Color(selectedColor))
                    })
                )
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $previewSheetToogle) {
            UserDetailsView_Sub()
        }
    }
}

extension UserProfileView {
    var likeProfileView: some View {
        ForEach(Object_ProfileViewModel.userLikedPosts) { posts in
            Question_Post_View(questionPost: posts, reloadDataBind: $reloadData)
        }
    }
}
extension UserProfileView {
    var postsProfileView: some View {
        ForEach(Object_ProfileViewModel.userPosts) { post in
            Question_Post_View(questionPost: post, reloadDataBind: $reloadData)
        }
    }
}


struct AllUserProfileView: View {
    
    @State var switchTabCount: Int = 0
    @State var tabCategory: [String] = ["Likes", "Queries"]
    @State var tabSelected: String = "Likes"
    @Namespace private var namepsace
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @State var reloadData: Bool = false
    @State var showProfilePhoto: Bool = false
    
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @ObservedObject var Object_ProfileViewModel: ProfileViewModel
    
    init(userInfo: RegisteredUserDataModel) {
        self.Object_ProfileViewModel = ProfileViewModel(userInfo: userInfo)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                VStack(spacing : 0) {
                    VStack(spacing: 0) {
                        VStack {
                            HStack(alignment: .top, spacing:3){
                                OnlyProfilePhotoView(url: Object_ProfileViewModel.userInfo.profilePicURL , key: Object_ProfileViewModel.userInfo.id ?? "")
                                    .onTapGesture {
                                        withAnimation(Animation.spring()) {
                                            showProfilePhoto.toggle()
                                        }
                                    }
                                
                                VStack(alignment: .leading, spacing: 0){
                                    HStack(alignment: .center,spacing: 3) {
                                        Text("\(Object_ProfileViewModel.userInfo.fullName)")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                        
                                        Image(systemName:Object_ProfileViewModel.userInfo.isVerfied ? "checkmark.seal.fill" : "")
                                            .foregroundColor(.teal)
                                            .font(.caption)
                                    }
                                    
                                    Text("@\(Object_ProfileViewModel.userInfo.userName)")
                                        .font(.caption)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 7)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.init(uiColor: .secondarySystemBackground))
                        .cornerRadius(13)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 0)
                        .padding(.bottom, 9)
                        
                        HStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Likes")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(Object_ProfileViewModel.userLikedPosts.count)")
                                        .font(.callout)
                                        .fontWeight(.medium)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.init(uiColor: .secondarySystemBackground))
                            .cornerRadius(13)
                            .padding(.horizontal, 2)
                            .padding(.vertical, 0)
                            .padding(.bottom, 9)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Queries")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(Object_ProfileViewModel.userPosts.count)")
                                        .font(.callout)
                                        .fontWeight(.medium)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.init(uiColor: .secondarySystemBackground))
                            .cornerRadius(13)
                            .padding(.vertical, 0)
                            .padding(.bottom, 9)
                        }
                        .padding(.bottom, 2)
                        .padding(.horizontal, 15)
                        
                        VStack(alignment: .leading, spacing: 0){
                            HStack {
                                ForEach(tabCategory, id: \.self) { index in
                                    ZStack {
                                        if tabSelected == index {
                                            RoundedRectangle(cornerRadius: 100)
                                                .foregroundColor(Color(selectedColor))
                                                .matchedGeometryEffect(id: "Tabs", in: namepsace)
                                        }
                                        Text("        \(index)        ")
                                            .fontWeight(tabSelected == index ? .medium : .regular)
                                            .foregroundColor(tabSelected == index ? .white : .gray)
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    tabSelected = index
                                                }
                                            }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 35)
                                }
                            }
                            .background(Color.init(.secondarySystemBackground))
                            .cornerRadius(100)
                            .padding(.bottom, 9)
                        }
                        .padding(.horizontal, 15)
                        
                        VStack {
                            switch tabSelected {
                            case "Likes":
                                if Object_ProfileViewModel.userLikedPosts.count == 0 {
                                    VStack(spacing: 0){
                                        LottieAnimationViews(fileName: "119180-sad-rainy-folder")
                                            .frame(width: 160, height: 160)
                                        Text("Nothing Liked Yet")
                                            .font(.headline)
                                            .foregroundColor(.primary.opacity(0.9))
                                            .fontWeight(.bold)
                                            .padding(.top, -10)
                                    }
                                    .padding(.top, 25)
                                } else {
                                    likeProfileView
                                }
                            case "Queries":
                                if Object_ProfileViewModel.userPosts.count == 0 {
                                    VStack(spacing: 0){
                                        LottieAnimationViews(fileName: "119180-sad-rainy-folder")
                                            .frame(width: 160, height: 160)
                                        Text("Nothing Posted Yet")
                                            .font(.headline)
                                            .foregroundColor(.primary.opacity(0.9))
                                            .fontWeight(.bold)
                                            .padding(.top, -10)
                                    }
                                    .padding(.top, 25)
                                } else {
                                    postsProfileView
                                }
                            default:
                                likeProfileView
                            }
                        }
                        Spacer()
                    }
                }
            }
            .refreshable {
                Object_ProfileViewModel.fetchLikedQuestion()
                Object_ProfileViewModel.fetchUserOwnPosts()
            }
            
            if showProfilePhoto {
                VStack {
                    AsyncImage(url: URL(string:Object_ProfileViewModel.userInfo.profilePicURL), content: { image in
                        withAnimation {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width/1.5))
                        }
                    }, placeholder: {
                        withAnimation {
                            RoundedRectangle(cornerRadius: UIScreen.main.bounds.width/1.5)
                                .frame(width: UIScreen.main.bounds.width/1.5, height:UIScreen.main.bounds.width/1.5)
                                .foregroundColor(.gray.opacity(0.3))
                                .overlay {
                                    LottieAnimationViews(fileName: "loadingImage")
                                        .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/1.5)
                                }
                        }
                    })
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    showProfilePhoto.toggle()
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

extension AllUserProfileView {
    var likeProfileView: some View {
        ForEach(Object_ProfileViewModel.userLikedPosts) { posts in
            Question_Post_View(questionPost: posts, reloadDataBind: $reloadData)
        }
    }
}

extension AllUserProfileView {
    var postsProfileView: some View {
        ForEach(Object_ProfileViewModel.userPosts) { post in
            Question_Post_View(questionPost: post, reloadDataBind: $reloadData)
        }
    }
}
