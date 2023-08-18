//  PostCardView.swift
//  Created by Aum Chauhan on 18/07/23.

import SwiftUI
import AlertToast
import FirebaseFirestore

struct PostCardView: View {
    
    let postContent: PostModel
    let postType: PostType
    let postOwnerUID: String
    let disableNavigation: Bool?
    private var postAllContentString: String = ""
    
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var viewModel = PostViewModel()
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var showReportConfirmation: Bool = false
    @State private var showReportSentSuccessFully: Bool = false
    
    init(postContent: PostModel, postOwnerUID: String, postType: PostType, disableNavigation: Bool? = nil) {
        self.postContent = postContent
        self.postOwnerUID = postOwnerUID
        self.postType = postType
        self.disableNavigation = disableNavigation
        
        // Clipoard And Share Link
        self.postAllContentString = "\(postContent.postContent.textSnippet)\n\(postContent.postContent.urlString)\n\(postContent.postContent.codeBlock)"
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                
                if showDeleteConfirmation {
                    deleteAlert
                } else if showReportConfirmation {
                    reportAlert
                } else {
                    userDetails
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .onFirstAppear {
            Task {
                // MARK: Fetching Post Owner Info
                await viewModel.fetchPostOwnerInfo(userUID: postOwnerUID)
                // MARK: Listner For Post Interactions
                viewModel.attachListnerToPostInteraction(postUID: postContent.postUID)
            }
        }
        
        // MARK: Reported Sucessfully Alert
        .toast(isPresenting: $showReportSentSuccessFully) {
            AlertToast(
                displayMode: .alert,
                type: .complete(.green),
                title: "Reported!",
                style: .style(backgroundColor: .theme.secondaryBackground)
            )
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
                    .foregroundColor(.gray).opacity(0.5)
                
                if !postContent.postAnalytics.postAnonymously {
                    // User's Profile Photo
                    if let postOwner = viewModel.postOwnerInfo {
                        ProfilePhotoView(userDetails: postOwner)
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    }
                } else {
                    // Anonymous Post Profile Photo
                    Image("person")
                        .foregroundColor(.theme.icon)
                        .circularButton(frameSize: 48, bgColor: .gray.opacity(0.55))
                }
            }
            
            // MARK: Name & Username
            VStack(alignment: .leading, spacing: 6) {
                if let postOwner = viewModel.postOwnerInfo {
                    UserInfoCardView(postOwner, showProfilePhoto: false, isAnonymous: postContent.postAnalytics.postAnonymously)
                } else {
                    UserInfoPlaceHolder()
                }
                
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
                VStack {
                    Text(postContent.postContent.textSnippet)
                        .font(.poppins(.regular, 14))
                        .foregroundColor(.theme.primaryTitle)
                }
                
                // URL
                if postContent.postContent.urlString != "" {
                    url
                }
                
                // MARK: Code Block
                if postContent.postContent.codeBlock != "" {
                    Text(postContent.postContent.codeBlock)
                        .codeBlockStyle()
                }
            }
            .multilineTextAlignment(.leading)
        }
        .disabled(disableNavigation ?? false)
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
                                .tagStyle()
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
            Button {
                // MARK: Like Action
                Task {
                    if authVM.isAlreadyLiked(postContent.postUID) {
                        await viewModel.removeFromLike(post: postContent)
                    } else {
                        await viewModel.likePost(post: postContent)
                    }
                }
            } label: {
                Image("like-1")
                    .foregroundColor(authVM.isAlreadyLiked(postContent.postUID) ? .theme.button : .theme.icon)
            }
            // Like Count
            Text("\(viewModel.postListner?.postAnalytics.likeCount ?? 0)")
            
            Spacer()
            
            // MARK: Views Count
            Image("eye")
                .foregroundColor(.theme.icon)
            Text("\(viewModel.postListner?.postAnalytics.views ?? 0)")
            
            Spacer()
            
            // MARK: Comments Count
            Image("message1")
                .foregroundColor(.theme.icon)
            Text("\(viewModel.postListner?.postAnalytics.repliesCount ?? 0)")
            
            Spacer()
            
            // MARK: Post Menu Button
            postMenu
        }
        .font(.poppins(.regular, 12))
        .foregroundColor(.theme.primaryTitle)
    }
    
    private var postMenu: some View {
        Menu {
            // MARK: Share Link
            ShareLink(item: postAllContentString) {
                HStack {
                    Text("Share")
                    Image("direct-send")
                }
            }
            
            Button {
                // MARK: Copy Content Action
                UIPasteboard.general.string = postAllContentString
                SoundService.playSound()
            } label: {
                Text("Copy")
                Image("paste")
            }
            
            if (authVM.userSession?.uid ?? "nil" == postContent.postOwnerUID) {
                Divider()
                Button(role: .destructive) {
                    // MARK: Delete Alert Action
                    withAnimation {
                        showDeleteConfirmation.toggle()
                    }
                } label: {
                    Text("Delete Post")
                    Image("trash")
                }
            }
            
            if !(authVM.userSession?.uid ?? "nil" == postContent.postOwnerUID) {
                Divider()

                Button(role: .destructive) {
                    // MARK: Report Alert Action
                    withAnimation {
                        showReportConfirmation.toggle()
                    }
                } label: {
                    Text("Report")
                    Image("danger")
                }
            }
        } label : {
            Image("share")
                .foregroundColor(.theme.icon)
        }
    }
    
    // MARK: Delete Alert
    private var deleteAlert: some View {
        PopUpAlertView(
            title: "Are You Sure?",
            alertMessage: "This action is permanent and cannot be undo.",
            buttonTittle: "Yes, Delete") {
                Task {
                    // MARK: Delete Post Action
                    await viewModel.deletePost(postId: postContent.postUID)
                    authVM.deletedCompleted = true
                }
            } dismiss: {
                showDeleteConfirmation.toggle()
            }
    }
    
    // MARK: Report Alert
    private var reportAlert: some View {
        PopUpAlertView(
            title: "Would You Like To Report?",
            alertMessage: "Your report will be reviewed by our team.",
            buttonTittle: "Report") {
                Task {
                    // MARK: Report Post Action
                    await viewModel.sentReport(post: postContent)
                    showReportConfirmation.toggle()
                    showReportSentSuccessFully.toggle()
                }
            } dismiss: {
                showReportConfirmation.toggle()
            }
    }
    
}

struct SinglePostView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardView(postContent: Debugging.debuggingPostContent, postOwnerUID: "sdygfuygsufiyguiygdius", postType: .newPost)
            .environmentObject(AuthenticationViewModel())
    }
}
