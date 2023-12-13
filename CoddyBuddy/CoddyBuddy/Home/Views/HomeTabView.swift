//  HomeTabView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI
import AlertToast

struct HomeTabView: View {
    
    private let filters: [MyFeedFilters] = [.recents, .anonymous, .following]
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var viewModel = HomeTabViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var namespace
    
    @State private var showSearchBar: Bool = false
    @Binding var showSideMenu: Bool
    
    var body: some View {
        NavigationHeaderView(title: "My Feed") {
            feedsAndNoPostsMessage
            
        } topLeading: {
            leadingButton
            
        } topTrailing: {
            trailingButton
            
        } subHeader: {
            if showSearchBar {
                searchBar
            } else {
                filterOptions
            }
            
        } refreshAction: {
            viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
        }
        .disabled(showSideMenu)
        .onFirstAppear {
            // MARK: Initial Fetch Request
            viewModel.fetchPosts(emptyPosts: false, user: authVM.userDetails)
        }
        // For Reloading Posts (After Create New Post Sheet Dismiss).
        .onReceive(authVM.$createPostSheetDismissied) { output in
            if output {
                viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
            }
        }
        // For Reloading Post After Delete Post Action
        .onReceive(authVM.$deletedCompleted) { didComplete in
            if didComplete {
                viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
            }
        }
        .onChange(of: viewModel.filterType) { oldValue, newValue in
            HapticManager.light()
        }
        
        // MARK: Alert
        .toast(isPresenting: $viewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception!",
                subTitle: viewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white)
            )
        }
        
    }
}


extension HomeTabView {
    
    // MARK: Feeds + No Post Found Msg
    private var feedsAndNoPostsMessage: some View {
        ZStack {
            // No Post Found For Search
            if viewModel.filterType == .search && viewModel.allPosts.isEmpty {
                noPostFound("🙁 No posts found for your search: \(viewModel.searchText).")
            }
            // No Post Found For Friends haven't posted yet
            else if viewModel.filterType == .following && viewModel.allPosts.isEmpty {
                noPostFound("🙁 It seems your friends haven't posted anything yet.")
            }
            // No Post Found For Empty Following List
            else if viewModel.filterType == .following && (authVM.userDetails?.userActivities.followingsUID.isEmpty ?? false) {
                noPostFound("🙁 You haven't followed anyone yet.\nStart exploring friends in the Discover section.")
            } else if viewModel.isLoading {
                postSkelton
            }
            else {
                feeds
            }
        }
    }
    // MARK: Feeds
    private var feeds: some View {
        LazyVStack(spacing: 15) {
            ForEach(viewModel.allPosts, id: \.self) { post in
                PostCardView(postContent: post, postOwnerUID: post.postOwnerUID, postType: .newPost)
                
                CustomDivider()
                
                // Paginatiion On Progrees View Appear
                if (post == viewModel.allPosts.last && viewModel.lastSnapDoc != nil) {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchPosts(emptyPosts: false, user: authVM.userDetails)
                        }
                }
            }
        }
        .padding(.bottom, 65) // Avoids TabBar Feed Collapse
    }
    
    // MARK: Leading Toolbar Item
    private var leadingButton: some View {
        Button {
            withAnimation(.spring()) {
                showSideMenu.toggle()
            }
        } label: {
            Image("menu")
                .scaleEffect(0.7)
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
    }
    
    // MARK: Trailing Toolbar Item
    private var trailingButton: some View {
        Button {
            // MARK: Show Search Bar Action
            withAnimation {
                showSearchBar.toggle()
            }
        } label: {
            Image(showSearchBar ? "filter-add" : "magnifyingGlass")
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
    }
    
    // MARK: Search Bar
    private var searchBar: some View {
        HStack {
            SearchBarView(text: $viewModel.searchText, showAutoKeyboardDismiss: false)
                .onDisappear {
                    viewModel.filterType = .recents
                    viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
                }
            
            if ValidationService.isValidSearchText(viewModel.searchText) {
                Button {
                    // MARK: Search Action Button
                    viewModel.filterType = .search
                    viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
                } label: {
                    Text("Search")
                        .inverseDynamicBackground()
                }
            }
        }
    }
    
    // MARK: Filter Options
    private var filterOptions: some View {
        HStack {
            ForEach(filters, id: \.self) { filter in
                // MARK: Selecting Filter Action
                Button {
                    withAnimation(.spring()) {
                        viewModel.filterType = filter
                        if !((viewModel.filterType == .following) && (authVM.userDetails?.userActivities.followingsUID.isEmpty ?? false)) {
                            viewModel.fetchPosts(emptyPosts: true, user: authVM.userDetails)
                        }
                    }
                } label: {
                    ZStack {
                        if viewModel.filterType == filter {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(maxHeight: .infinity)
                                .foregroundColor(.theme.inverseBackground)
                                .matchedGeometryEffect(id: "tab", in: namespace)
                        }
                        
                        Text("\(filter.rawValue)")
                            .font(.poppins(.medium, 14))
                            .foregroundColor(filter == viewModel.filterType ? .theme.inverseTitle : .theme.secondaryTitle)
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .tint(.primary)
            }
        }
        .bgFillToInfinity(height: 48)
    }
    
    private var postSkelton: some View {
        VStack {
            ForEach(0..<4) { item in
                HStack {
                    Lottie(fileName: "postSkelton2")
                }
                .opacity(colorScheme == .light ? 1.0 : 0.1)
                .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width * 1.2)
                .scaleEffect(1.1)
            }
        }
        .padding(.top, 5)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeTabView(showSideMenu: .constant(false))
                .environmentObject(AuthenticationViewModel())
        }
    }
}
