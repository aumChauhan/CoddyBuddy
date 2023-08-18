//  RepliesView.swift
//  Created by Aum Chauhan on 30/07/23.

import SwiftUI

struct RepliesView: View {
    
    let post: PostModel
    
    @EnvironmentObject var autheticationVM: AuthenticationViewModel
    
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var viewModel = RepliesViewModel()
    
    @State private var showReplySheet: Bool = false
    
    var body: some View {
        
        NavigationHeaderView(title: "") {
            
            // Post
            PostCardView(postContent: post, postOwnerUID: post.postOwnerUID, postType: .newPost, disableNavigation: true)
                .padding(.top, -38)
            
            divider
            
            if viewModel.allPosts.isEmpty {
                noPostFound("😶‍🌫️ No replies have been provided in this post.")
                    .padding(.top, 10)
            } else {
                replies
            }
                
        } topLeading: {
            // Dismiss Button
            DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
            
        } topTrailing: {
            replyButton
            
        } subHeader: { }
            .navigationBarBackButtonHidden(true)
            .onFirstAppear {
                Task {
                    // MARK: Initial Fetch Request
                    await viewModel.fetchPosts(fromPostUID: post.postUID, emptyPosts: false)
                    // MARK: Update Replies Count
                    await postViewModel.updateViewCountToPost(post: post)
                }
            }
        // Reloads Replies After Posting Rely
            .onReceive(autheticationVM.$createPostSheetDismissied) { output in
                if output {
                    Task {
                        await viewModel.fetchPosts(fromPostUID: post.postUID, emptyPosts: true)
                    }
                }
            }
        // Reloads Replies After Deleting Reply
            .onReceive(autheticationVM.$deletedCompleted) { output in
                if output {
                    Task {
                        await viewModel.fetchPosts(fromPostUID: post.postUID, emptyPosts: false)
                    }
                }
            }
        
        // MARK: New Reply Sheet
            .sheet(isPresented: $showReplySheet) {
                CreatePostView(postType: .reply, post: post)
                    .interactiveDismissDisabled(true)
            }
    }
}

extension RepliesView {
    
    // MARK: Divider
    private var divider: some View {
        VStack {
            CustomDivider()
            HStack {
                Text("Replies")
                    .font(.poppins(.semiBold, 14))
                Spacer()
                
                Text("\(post.postAnalytics.repliesCount)")
                    .font(.poppins(.semiBold, 14))
            }
            CustomDivider()
        }
    }
    
    // MARK: Replies
    private var replies: some View {
        LazyVStack(spacing: 15) {
            // Replies
            ForEach(viewModel.allPosts, id: \.self) { replies in
                ReplyCardView(reply: replies, postContent: post, postOwnerUID: replies.postOwnerUID)
                
                CustomDivider()
                
                if (replies == viewModel.allPosts.last && viewModel.lastSnapDoc != nil) {
                    ProgressView()
                        .task {
                            await viewModel.fetchPosts(fromPostUID: post.postUID, emptyPosts: false)
                        }
                }
            }
        }
    }
    
    // MARK: Reply Button
    private var replyButton: some View {
        Button {
            showReplySheet.toggle()
        } label: {
            HStack {
                Text("Reply")
                    .font(.poppins(.medium, 14))
                Image("edit(1)")
            }
            .foregroundColor(.theme.inverseTitle)
            .padding(15)
            .dynamicBgFill(height: iconHeight, bgColor: .theme.inverseBackground)
        }
    }
}
struct RepliesView_Previews: PreviewProvider {
    static var previews: some View {
        RepliesView(post: Debugging.debuggingPostContent)
    }
}
