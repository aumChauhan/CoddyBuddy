//  TrendingTabView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI

struct ExploreTabView: View {
    
    @StateObject private var viewModel = ExploreViewModel()
    @StateObject private var chatRoomViewModel = ChatRoomViewModel()
        
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationHeaderView(title: "Explore") {
            if viewModel.isLoading {
                skelton
            } else if viewModel.searchText.isEmpty {
                VStack(spacing: 24) {
                    popularChatRooms
                    
                    popularTags
                    
                    popularPosts
                }
                .padding(.bottom, 60)
            } else if (viewModel.users.isEmpty) && (viewModel.searchText.count >= 1) {
                noPostFound("🙁 No No posts found for your search: \(viewModel.searchText)")
            } else {
                users
            }
            
        } topLeading: {
            leadingToolbarItem
            
        } topTrailing: {
            leadingToolbarItem.opacity(0.0)
            
        } subHeader: {
            searchBar
            
        } refreshAction: {
            // Refresh Action
            viewModel.fetchAll()
        }
        .task {
            // MARK: Fetch Request
            viewModel.fetchAll()
        }
        
    }
}

extension ExploreTabView {
    
    // MARK: Search Bar
    private var searchBar: some View {
        HStack {
            SearchBarView(text: $viewModel.searchText, showAutoKeyboardDismiss: false)
            
            if ValidationService.isValidSearchText(viewModel.searchText) {
                Button {
                    // MARK: Search Action Button
                    viewModel.fetchUsers()
                } label: {
                    Text("Search")
                        .inverseDynamicBackground()
                }
                .onDisappear {
                    viewModel.users = []
                }
            }
        }
    }
    
    // MARK: Leading Toolbar Content
    private var leadingToolbarItem: some View {
        Button {
            // TODO: Add Profile Sheet Toogle
            
        } label: {
            Image("person")
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
    }
    
    // MARK: User Lists
    private var users: some View {
        LazyVStack {
            ForEach(viewModel.users, id: \.self) { user in
                NavigationLink {
                    UserProfileTabView(user: user, isProfileTab: false)
                } label: {
                    UserInfoCardView(user, showNavigator: true)
                }
                CustomDivider()
            }
        }
    }
    
    // MARK: Popular ChatRooms
    private var popularChatRooms: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Popular Chat Rooms")
                .font(.poppins(.semiBold, 16))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(viewModel.chatRooms, id: \.self) { chatRoom in
                        NavigationLink {
                            ChatRoomMessagesView(title: chatRoom.chatRoomName)
                        } label: {
                            ChatRoomCardView(chatRoom: chatRoom, lineLimit: 1)
                                .frame(width: UIScreen.main.bounds.width / 1.3 )
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Popular Tags
    private var popularTags: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Popular Tags")
                .font(.poppins(.semiBold, 16))
            
            ScrollView {
                FlowLayout(viewModel.tags, \.tagName, spacing: 5) { item in
                    NavigationLink {
                        TagsFilterView(tag: item.tagName)
                    } label: {
                        Text("#\(item.tagName)")
                            .tagStyle()
                    }
                }
            }
        }
    }
    
    // MARK: Popular Posts
    private var popularPosts: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Popular Posts")
                .font(.poppins(.semiBold, 16))
            
            LazyVStack(spacing: 14) {
                ForEach(viewModel.popularPosts, id: \.self) { post in
                    PostCardView(postContent: post, postOwnerUID: post.postOwnerUID, postType: .newPost)
                    CustomDivider()
                }
            }
        }
    }
    
    private var skelton: some View {
        VStack {
            Group {
                Lottie(fileName: "exploreTabSkelton")
            Lottie(fileName: "postSkelton2")
                    .padding(.top, 15)
            }
            .opacity(colorScheme == .light ? 1.0 : 0.1)
            .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width * 1.2)
            .scaleEffect(1.1)
        }
    }
}
struct ExploreTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExploreTabView()
        }
        .environmentObject(AuthenticationViewModel())
    }
}
