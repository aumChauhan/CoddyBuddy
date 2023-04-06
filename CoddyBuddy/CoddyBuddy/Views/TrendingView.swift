import SwiftUI

struct TrendingView: View {
    
    @ObservedObject var Obj_FetchUserQueriesOn_HomeTab_ViewModel = FetchUserQueriesOn_HomeTab_ViewModel()
    @ObservedObject var exploreFetchDataObject = ExploreSection_ViewModel()
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State var countDown: Int = 1
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @State var reloadData: Bool = false
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("togglePromotion") var togglePromotion: Bool = true
    
    var body: some View {
        ScrollView {
            if togglePromotion {
                AdsBanner()
            }
            VStack(spacing: 0) {
                
                HStack {
                    Text("Verified Profiles")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.top, 5)
                .padding(.bottom, 7)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(exploreFetchDataObject.verfiedUser) { index in
                            NavigationLink {
                                AllUserProfileView(userInfo: index)
                            } label: {
                                Trending_userProfile(profilePicURL: index.profilePicURL, userName: index.userName, fullName: index.fullName, isVerified: index.isVerfied )
                            }
                            
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
                
                HStack {
                    Text("Trending Post")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.top, 5)
                .padding(.bottom, 7)
                
                VStack {
                    ForEach(Obj_FetchUserQueriesOn_HomeTab_ViewModel.fetchedQueryDataArray.filter({$0.likes >= 2})) { posts in
                        VStack {
                            Question_Post_View(questionPost: posts, reloadDataBind: $reloadData)
                        }
                    }
                }
                .refreshable {
                    Obj_FetchUserQueriesOn_HomeTab_ViewModel.fetchUserQuieries()
                }
            }
        }
        .refreshable {
            Obj_FetchUserQueriesOn_HomeTab_ViewModel.fetchUserQuieries()
        }
    }
}

struct Trending_userProfile: View {
    
    @State var profilePicURL: String
    @State var userName: String
    @State var fullName: String
    @State var isVerified: Bool
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 10){
                AsyncImage(url: URL(string: profilePicURL), content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }, placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay {
                            LottieAnimationViews(fileName: "loadingImage")
                                .frame(width: 50, height: 50)
                        }
                })
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing:2) {
                        Text("\(fullName)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Image(systemName:  isVerified ? "checkmark.seal.fill" : "")
                            .foregroundColor(.teal)
                            .font(.caption)
                    }
                    Text("@\(userName)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                VStack {
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .opacity(0.6)
                }
            }
        }
        .padding(11)
        .background(Color.init(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct AdsBanner: View {
    
    let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    @State var countDown: Int = 1
    @StateObject var Obj_RecommendationModel = Recommendation_VM()
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text("Recommendation")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 15)
            
            HStack(spacing: 12){
                ZStack {
                    TabView(selection: $countDown) {
                        AsyncImage(url: URL(string: Obj_RecommendationModel.Ad1_URL), content: { image in
                            image
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .scaledToFill()
                                .cornerRadius(13)
                            
                        }, placeholder: {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .foregroundColor(.gray.opacity(0.4))
                                .overlay {
                                    ProgressView()
                                        .tint(.gray)
                                }
                        })
                        .tag(1)
                        
                        AsyncImage(url: URL(string: Obj_RecommendationModel.Ad2_URL), content: { image in
                            image
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .scaledToFill()
                                .cornerRadius(13)
                            
                        }, placeholder: {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .foregroundColor(.gray.opacity(0.4))
                                .overlay {
                                    ProgressView()
                                        .tint(.gray)
                                }
                        })
                        .tag(2)
                        
                        AsyncImage(url: URL(string: Obj_RecommendationModel.Ad3_URL), content: { image in
                            image
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .scaledToFill()
                                .cornerRadius(13)
                            
                        }, placeholder: {
                            RoundedRectangle(cornerRadius: 13)
                                .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                                .foregroundColor(.gray.opacity(0.4))
                                .overlay {
                                    ProgressView()
                                        .tint(.gray)
                                }
                        })
                        .tag(3)
                    }
                    .frame(width: UIScreen.main.bounds.width/1.09, height: UIScreen.main.bounds.width/2.6)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .cornerRadius(14)
                }
                .onReceive(timer) { _ in
                    withAnimation {
                        countDown = countDown == 3 ? 1 : countDown + 1
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 7)
        }
    }
}
