//  UserProfileTabView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI
import SwiftUITrackableScrollView

struct UserProfileTabView: View {
    
    private let tabs = [
        ("Posts", 1),
        ("Followers", 2),
        ("Followings", 3)
    ]
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    @StateObject private var viewModel = UserProfileViewModel()
    @StateObject private var homeVM = HomeTabViewModel()
    
    @State var user: UserProfileModel?
    @State var isProfileTab: Bool
    
    @State var showProfilePhoto: Bool = false
    @State var selectedTab: Int = 1
    
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var scrollPosition: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            content
            
            if showProfilePhoto {
                ProfilePhotoEnlargeView(user: viewModel.userInfo, dismiss: $showProfilePhoto)
            }
        }
        // MARK: Fetch Request
        .onFirstAppear {
            Task {
                // Fetching User Info
                await viewModel.getUserInfo(forUID: user?.userUID ?? "nil")
                
                // Fetching User's Posts
                homeVM.fetchPosts(filter: .user, emptyPosts: false, user: user)
                
                if let user {
                    await viewModel.getFollowers(user: user)
                    await viewModel.getFollowings(user: user)
                }
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}

extension UserProfileTabView {
    
    private var content: some View {
        VStack {
            // MARK: Pinned toolbar
            VStack(spacing: 15) {
                toolBar
            }
            .background(Color.theme.background)
            .padding(.bottom, 10)
            
            // Content
            postsAndProfiles
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: Toolbar
    private var toolBar: some View {
        HStack(alignment: .center) {
            // MARK: Leading ToolbarItem
            if !isProfileTab {
                DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
            } else if isCurrentUser()  {
                Button {
                    authVM.signOutUser()
                } label: {
                    Image("share")
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundColor(.red)
                        .circularButton(frameSize: iconHeight)
                }
            }
            
            // MARK: Pinned Title
            if scrollPosition > 30 {
                Text(viewModel.userInfo?.fullName ?? "...")
                    .font(.poppins(.medium, 16))
                    .foregroundColor(.theme.primaryTitle)
                    .padding(.horizontal, 4)
            }
            Spacer()
        }
    }
    
    // MARK: User Info
    private var userInfo: some View {
        HStack(alignment: .center) {
            // MARK: Profile Photo
            if (viewModel.userInfo != nil) {
                ProfilePhotoView(userDetails: viewModel.userInfo!)
                    .frame(width: 60, height: 60)
                    .cornerRadius(100)
                    .onTapGesture {
                        withAnimation {
                            showProfilePhoto.toggle()
                        }
                    }
            } else {
                Circle().frame(width: 60, height: 60).opacity(0.2)
            }
            
            // MARK: Name & User Name
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.userInfo?.fullName ?? "")
                    .font(.poppins(.semiBold, 17))
                Text("@\(viewModel.userInfo?.userName ?? "")")
                    .font(.poppins(.medium, 14))
            }
            .foregroundColor(.theme.primaryTitle)
            Spacer()
        }
    }
    
    // MARK: Analytics Card
    private func analytics(_ title: String, _ data: Int?) -> some View {
        VStack {
            Text("\(data ?? 0)")
                .font(.poppins(.semiBold, 16))
                .foregroundColor(.theme.primaryTitle)
            Text(title)
                .font(.poppins(.medium, 12))
                .foregroundColor(.theme.secondaryTitle)
        }
    }
    
    // MARK: Posts + Profiles
    private var postsAndProfiles: some View {
        TrackableScrollView(showIndicators: false, contentOffset: $scrollViewContentOffset) {
            VStack(alignment: .leading) {
                
                userInfo
                
                Text("Joined On : \(viewModel.userInfo?.joinedOn.formatted(date: .abbreviated, time: .omitted) ?? "")")
                    .font(.poppins(.medium, 13))
                    .foregroundColor(.theme.secondaryTitle)
                    .padding(.top, 4)
                
                // MARK: Analytics Count
                HStack {
                    analytics("Followers", viewModel.userInfo?.userActivities.followerCount)
                    Spacer()
                    
                    analytics("Following", viewModel.userInfo?.userActivities.followingCount)
                    Spacer()
                    
                    analytics("Posts", viewModel.userInfo?.userActivities.postCount)
                    Spacer()
                    
                    followButton
                }
                .padding(.horizontal, 5)
                
                // MARK: Segmented Control
                SegmentedControlView(tabs: tabs, selectedTab: $selectedTab, height: 50)
                    .padding(.top, 13)
                
                // Posts + Friends List
                Group {
                    if selectedTab == 1 {
                        userPosts
                    } else if selectedTab == 2 {
                        followersList
                    } else {
                        followingLists
                    }
                }
                .padding(.top, 13)
                .padding(.bottom, 65) // Avoids TabBar Feed Collapse
                
                Spacer()
            }
        }
        .onChange(of: scrollViewContentOffset) { newValue in
            withAnimation(.spring()) {
                scrollPosition = scrollViewContentOffset
            }
        }
        // MARK: Refresh Action
        .refreshable {
            Task {
                user = viewModel.userInfo
                // Fetching User's Posts
                homeVM.fetchPosts(filter: .user, emptyPosts: false, user: user)
                if let user {
                    await viewModel.getFollowers(user: user, emptyData: true)
                    await viewModel.getFollowings(user: user, emptyData: true)
                }
            }
            
        }
    }
    
    // MARK: Follow Button
    private var followButton: some View {
        Button {
            if authVM.isFriend(viewModel.userInfo?.userUID) {
                Task {
                    await authVM.unFollow(toUser: viewModel.userInfo?.userUID ?? "nil")
                }
            } else {
                Task {
                    await authVM.follow(toUser: viewModel.userInfo?.userUID ?? "nil")
                }
            }
        } label: {
            HStack {
                Image("person")
                Text(authVM.isFriend(viewModel.userInfo?.userUID) ? "Following" : "Follow")
            }
            .foregroundColor(authVM.isFriend(viewModel.userInfo?.userUID) ? .gray : .white)
            .font(.poppins(.semiBold, 14))
            .frame(width: 140)
            .dynamicBgFill(
                bgColor: authVM.isFriend(viewModel.userInfo?.userUID) ? .theme.secondaryBackground : .theme.button.opacity(0.9)
            )
        }
    }
    
    // MARK: User Posts
    private var userPosts: some View {
        LazyVStack(spacing: 15) {
            if homeVM.allPosts.isEmpty {
                noPostFound("🙁 \(user?.userName.capitalized ?? "User") haven't post anything yet.")
            } else {
                ForEach(homeVM.allPosts, id: \.self) { post in
                    PostCardView(postContent: post, postOwnerUID: post.postOwnerUID, postType: .newPost)
                    
                    CustomDivider()
                    
                    // MARK: Fetch Request
                    if (post == homeVM.allPosts.last && homeVM.lastSnapDoc != nil) {
                        ProgressView()
                            .onAppear {
                                homeVM.fetchPosts(filter: .user, emptyPosts: false, user: user)
                            }
                    }
                }
            }
        }
    }
    
    // MARK: Following List
    private var followingLists: some View {
        LazyVStack {
            if viewModel.followings.isEmpty {
                noPostFound("🙁 \(user?.fullName.capitalized ?? "User")'s following list is empty.")
            } else {
                ForEach(viewModel.followings, id: \.userUID) { item in
                    NavigationLink {
                        UserProfileTabView(user: item, isProfileTab: false)
                    } label: {
                        UserInfoCardView(item, showNavigator: true)
                    }
                    
                    CustomDivider()
                    
                    // MARK: Fetch Request
                    if (item == viewModel.followings.last && viewModel.followingsLastSnapDoc != nil) {
                        ProgressView()
                            .task {
                                if let user {
                                    await viewModel.getFollowings(user: user)
                                }
                            }
                    }
                }
            }
        }
    }
    
    // MARK: Following List
    private var followersList: some View {
        LazyVStack {
            if viewModel.followers.isEmpty {
                noPostFound("🙁 \(user?.fullName.capitalized ?? "User")'s Followers list is empty.")
            } else {
                ForEach(viewModel.followers, id: \.userUID) { item in
                    NavigationLink {
                        UserProfileTabView(user: item, isProfileTab: false)
                    } label: {
                        UserInfoCardView(item, showNavigator: true)
                    }
                    
                    CustomDivider()
                    
                    // MARK: Fetch Request
                    if (item == viewModel.followers.last && viewModel.followersLastSnapDoc != nil) {
                        ProgressView()
                            .task {
                                if let user {
                                    await viewModel.getFollowers(user: user)
                                }
                            }
                    }
                }
            }
        }
    }
    
    // Checks User Session Is Same As Current Session
    func isCurrentUser() -> Bool {
        return user?.userUID == authVM.userDetails?.userUID
    }
}

// TODO: Move To New File
struct ProfilePhotoEnlargeView: View {
    
    let user: UserProfileModel?
    @Binding var dismiss: Bool
    
    var body: some View {
        VStack {
            Spacer()
            if let user {
                ProfilePhotoView(userDetails: user)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                    .cornerRadius(200)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation {
                dismiss.toggle()
            }
        }
    }
}

struct UserProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileTabView(user: Debugging.debuugingProfile, isProfileTab: true)
            .environmentObject(AuthenticationViewModel())
    }
}
