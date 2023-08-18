//  SinglePostView.swift
//  Created by Aum Chauhan on 18/07/23.

import SwiftUI
import FirebaseFirestore

struct PostCardView: View {
    
    let postContent: PostModel
    let postOwnerUID: String
    let postType: NewPostType
    
    @State var postListner: PostModel? = nil
    let postService = PostService()
    
    @Environment(\.openURL) var openURL
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var viewModel = PostViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            userDetails
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchPostOwnerInfo(userUID: postOwnerUID)
                // await viewModel.isPostLiked(post: postContent)
                await viewModel.repliesCount(postUID: postContent.postUID)
                await postService.attachListnerToPostInteraction(postUID: postContent.postUID, completionHandler: { post in
                    self.postListner = post
                })
            }
        }
    }
}

extension PostCardView {
    
    // MARK: User Details
    private var userDetails: some View {
        HStack(alignment: .top, spacing: 10) {
            
            // MARK: Profile Pic
            ZStack {
                // PlaceHolder
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.gray).opacity(0.6)
                
                if viewModel.postOwnerInfo?.profilePicURL.isEmpty ?? false {
                    // Initial Letter Profile
                    DefaulProfilePhotoView(name: viewModel.postOwnerInfo?.fullName)
                    
                } else if let postOwnerInfo = viewModel.postOwnerInfo {
                    if !postContent.postAnalytics.postAnonymously {
                        // Actual Profile
                        ProfilePhotoView(userDetails: postOwnerInfo)
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    } else {
                        // Anonymous Post Profile Pic
                        Image("person")
                            .customButtonStyle(frameSize: 48, bgColor: .gray.opacity(0.55))
                    }
                }
            }
            
            // MARK: Name & Username
            VStack(alignment: .leading, spacing: 6) {
                UserInfoCellView(
                    name: postContent.postAnalytics.postAnonymously ? "Anonymous" :
                        "\(viewModel.postOwnerInfo?.fullName ?? "")",
                    userName: postContent.postAnalytics.postAnonymously ? "anonymous" :
                        "\(viewModel.postOwnerInfo?.userName ?? "")",
                    showProfilePhoto: false,
                    isVerified: viewModel.postOwnerInfo?.isVerified ?? false
                )
                
                // Post Content + Tags + Interaction Buttons
                VStack(alignment: .leading, spacing: 12) {
                    postContents
                    
                    if postContent.postContent.tags != ["", "", "", "", ""]  {
                        tags
                    }
                    
                    postInteraction
                }
            }
        }
    }
    
    // MARK: Post Content
    private var postContents: some View {
        NavigationLink {
            RepliesView(post: postContent)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                // MARK: Text Snippet
                Text(postContent.postContent.textSnippet)
                    .font(.poppins(.regular, 14))
                    .foregroundColor(.theme.primaryTitle)
                
                // URL
                if postContent.postContent.urlString != "" {
                    url
                }
                
                // MARK: Code block
                if postContent.postContent.codeBlock != "" {
                    Text(postContent.postContent.codeBlock)
                        .codeBlock()
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: URL Button
    private var url: some View {
        HStack {
            Button {
                openURL(URL(string: postContent.postContent.urlString)!)
            } label: {
                Text(postContent.postContent.urlString)
                    .font(.poppins(.regular, 14))
                    .foregroundColor(.theme.button)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: Tags H-ScrollView
    private var tags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(postContent.postContent.tags, id: \.self) { tag in
                    if tag != "" {
                        NavigationLink {
                            // MARK: Detailed Tag View
                            TagsFilterView(tag: tag)
                        } label: {
                            Text("#\(tag)")
                                .singleTag()
                                .padding(2)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Post Interactions Buttons
    private var postInteraction: some View {
        HStack(spacing: 6) {
            // MARK: Like Button
            Button {
                Task {
                    if authenticationViewModel.userDetails?.userActivities.likedPostsId.contains(postContent.postUID) ?? false {
                        await viewModel.removeFromLike(post: postContent)
                    } else {
                        await viewModel.likePost(post: postContent)
                    }
                }
            } label: {
                Image("like-1")
                    .foregroundColor(authenticationViewModel.userDetails?.userActivities.likedPostsId.contains(postContent.postUID) ?? false ? .green : .primary)
                    .opacity(viewModel.isPostAlreadyLiked ? 1 : Debugging.iconOpacity)
            }
            
            // Text("\(postContent.postAnalytics.likes)")
            Text("\(postListner?.postAnalytics.likeCount ?? 0)")
            
            Spacer()
            
            // MARK: Views Count
            Image("eye")
                .opacity(Debugging.iconOpacity)
            //Text("\(postContent.postAnalytics.views)")
            Text("\(postListner?.postAnalytics.views ?? 0)")
            
            Spacer()
            
            // MARK: Comments Count
            Image("message1")
                .opacity(Debugging.iconOpacity)
            Text("\(viewModel.repliesCount)")
            
            Spacer()
            
            // MARK: Share Button
            Image("share")
                .opacity(Debugging.iconOpacity)
        }
        .font(.poppins(.regular, 12))
        .foregroundColor(.theme.primaryTitle)
    }
}

//struct SinglePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SinglePostView(postContent: Debugging.debuggingPostContent, postOwnerUID: "sdygfuygsufiyguiygdius", postType: .newPost)
//    }
//}
