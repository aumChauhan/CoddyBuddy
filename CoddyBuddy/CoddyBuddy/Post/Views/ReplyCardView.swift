//  ReplyCardView.swift
//  Created by Aum Chauhan on 30/07/23.

import SwiftUI
import AlertToast

struct ReplyCardView: View {
    
    let reply: ReplyPostDataModel
    let postContent: PostModel
    let postOwnerUID: String
    var postAllContentString: String = ""
    
    @Environment(\.openURL) var openURL
    @StateObject var viewModel = RepliesViewModel()
    @StateObject var postViewModel = PostViewModel()
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    @State var showDeleteConfirmation: Bool = false
    @State var showReportConfirmation: Bool = false
    @State var showReportSentSuccessFully: Bool = false
    
    init(reply: ReplyPostDataModel, postContent: PostModel, postOwnerUID: String) {
        self.reply = reply
        self.postContent = postContent
        self.postOwnerUID = postOwnerUID
        
        // Clipoard And Share Link
        self.postAllContentString = "\(reply.postContent.textSnippet)\n\(reply.postContent.urlString)\n\(reply.postContent.codeBlock)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if showDeleteConfirmation {
                deleteAlert
            } else if showReportConfirmation {
                reportAlert
            } else {
                userDetails
            }
        }
        .navigationBarBackButtonHidden(true)
        .onFirstAppear {
            Task {
                // MARK: Reply Owner Info
                await postViewModel.fetchPostOwnerInfo(userUID: postOwnerUID)
                // MARK: Listner
                viewModel.replyListner(replyToUID: reply.replyToPostUID, replyUID: reply.postUID)
            }
        }
        
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

extension ReplyCardView {
    
    // MARK: User Details
    private var userDetails: some View {
        HStack(alignment: .top, spacing: 10) {
            // MARK: Profile Pic
            ZStack {
                if !reply.postAnalytics.postAnonymously {
                    // User's Profile Photo
                    if let postOwnerInfo = postViewModel.postOwnerInfo {
                        ProfilePhotoView(userDetails: postOwnerInfo)
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    } else {
                        // PlaceHolder
                        Circle()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.gray).opacity(0.6)
                    }
                } else {
                    // Anonymous Post Profile Photo
                    Image("person")
                        .foregroundColor(.secondary)
                        .circularButton(frameSize: 48, bgColor: .gray.opacity(0.55))
                }
            }
            
            // MARK: Name & Username
            VStack(alignment: .leading, spacing: 6) {
                
                if let postOwner = postViewModel.postOwnerInfo {
                    UserInfoCardView(
                        postOwner, showProfilePhoto: false,
                        isAnonymous: reply.postAnalytics.postAnonymously)
                } else {
                    UserInfoPlaceHolder()
                }
                
                // Post Content + Tags + Interaction Buttons
                VStack(alignment: .leading, spacing: 12) {
                    postContents
                    
                    if reply.postContent.tags != ["", "", "", "", ""]  {
                        tags
                    }
                    
                    postInteraction
                }
            }
        }
    }
    
    // MARK: Post Content
    private var postContents: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: Text Snippet
            Text(reply.postContent.textSnippet)
                .font(.poppins(.regular, 14))
                .foregroundColor(.theme.primaryTitle)
            
            // URL
            if reply.postContent.urlString != "" {
                url
            }
            
            // MARK: Code block
            if reply.postContent.codeBlock != "" {
                Text(reply.postContent.codeBlock)
                    .codeBlockStyle()
            }
        }
    }
    
    // MARK: URL Button
    private var url: some View {
        HStack {
            Button {
                openURL(URL(string: reply.postContent.urlString)!)
            } label: {
                Text(reply.postContent.urlString)
                    .font(.poppins(.regular, 14))
                    .foregroundColor(.theme.tint)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: Tags H-ScrollView
    private var tags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(reply.postContent.tags, id: \.self) { tag in
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
                // MARK: Like Button
                Task {
                    if authVM.isAlreadyLiked(reply.postUID) {
                        await viewModel.removeFromLike(post: postContent, reply: reply)
                    } else {
                        await viewModel.likePost(post: postContent, reply: reply)
                    }
                }
            } label: {
                Image("like-1")
                    .foregroundColor(authVM.isAlreadyLiked(reply.postUID) ? .green : .theme.icon)
            }
            
            Text("\(viewModel.postListner?.postAnalytics.likeCount ?? 0)")
            
            Spacer()
            
            // MARK: Share Button
            ShareLink(item: postAllContentString) {
                Image("share")
                    .foregroundColor(.theme.icon)
            }
            
            Spacer()
            
            
            Button {
                // MARK: Copy Content Action
                UIPasteboard.general.string = postAllContentString
                SoundService.playSound()
            } label: {
                Image("paste")
                    .foregroundColor(.theme.icon)
            }
            
            Spacer()
            
            if (authVM.userSession?.uid ?? "nil" == reply.postOwnerUID) {
                Button {
                    // MARK: Delete Alert Toogle
                    withAnimation {
                        showDeleteConfirmation.toggle()
                    }
                } label: {
                    Image("trash")
                        .foregroundColor(.red)
                }
            }
            
            if !(authVM.userSession?.uid ?? "nil" == reply.postOwnerUID) {
                Button {
                    // MARK: Report Alert Toogle
                    withAnimation {
                        showReportConfirmation.toggle()
                    }
                } label: {
                    Image("danger")
                        .foregroundColor(.red)
                }
            }
            
        }
        .foregroundColor(.theme.primaryTitle)
        .font(.poppins(.regular, 12))
    }
    
    // MARK: Delete Alert
    private var deleteAlert: some View {
        PopUpAlertView(
            title: "Are You Sure?",
            alertMessage: "This action is permanent and cannot be undo.",
            buttonTittle: "Yes, Delete") {
                Task {
                    // MARK: Delete Post Action
                    await viewModel.deleteReplyFromPost(repliedTo: reply.replyToPostUID ,replyUID: reply.postUID)
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
                    await viewModel.reportReply(reply: reply)
                    showReportConfirmation.toggle()
                    showReportSentSuccessFully.toggle()
                }
            } dismiss: {
                showReportConfirmation.toggle()
            }
    }
    
}

struct SingleReplyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyCardView(reply: Debugging.debuggingReplyContent, postContent: Debugging.debuggingPostContent, postOwnerUID: "oihoiu")
            .environmentObject(AuthenticationViewModel())
    }
}
