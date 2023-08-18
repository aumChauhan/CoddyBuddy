//  CreatePostView.swift
//  Created by Aum Chauhan on 19/07/23.

import SwiftUI
import AlertToast
import WaterfallGrid

struct CreatePostView: View {
    
    let postType: PostType
    let post: PostModel?
    
    init(postType: PostType, post: PostModel? = nil) {
        self.postType = postType
        self.post = post
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var autheticationVM: AuthenticationViewModel
    @StateObject private var viewModel = PostViewModel()
    
    @State private var selectedOption: Int = 1
    @State private var textEditorTitle: String = "Text Snippet"
    
    private let postOptions = [
        ("Text", 1),
        ("Code", 2),
        ("Tags", 3),
        ("URL", 4)
    ]
    
    var body: some View {
        VStack {
            HeaderWithDismissButton(title: postType == .newPost ? "Create New Post" : "Reply")
            
            VStack(alignment: .leading, spacing: 16) {
                userInfoAndPublishButton
                
                postTools
                
                textEditor
            }
        }
        // MARK: Alert
        .toast(isPresenting: $viewModel.errorOccured) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .systemImage("exclamationmark.triangle.fill", .white),
                title: "Exception Occured!", subTitle: viewModel.errorDescription,
                style: .style(backgroundColor: .red, titleColor: .white, subTitleColor: .white))
        }
        // View Styling
        .padding(20)
        .background(Color.theme.background)
        // Dismiss Sheet On Publishing Post
        .onReceive(viewModel.$postPublishedStatus.dropFirst()) { isPublished in
            dismiss()
            autheticationVM.createPostSheetDismissied = true
        }
    }
}

extension CreatePostView {
    
    // MARK: Publish Button
    private var publishButton: some View {
        HStack {
            Spacer()
            Button {
                // MARK: Publish Post Action
                Task {
                    await viewModel.publishPost(
                        postType:postType,
                        replyToPostUID: post?.postUID ?? "",
                        replyToPostOwnersUID: post?.postOwnerUID ?? ""
                    )
                }
            } label: {
                Image("send-2")
                    .contrast(2)
                    .foregroundColor(.white)
                    .circularGradientButton(frameSize: 45)
                    .padding(.trailing, 7)
            }
        }
    }
    
    private var userInfoAndPublishButton: some View {
        HStack {
            if let user = autheticationVM.userDetails {
                UserInfoCardView(user, isAnonymous: viewModel.isPostAnonymous)
            }
            
            Spacer()
            
            postAnonymous
        }
        .padding(.horizontal, 9)
        .bgFillToInfinity(height: 65, radius: 20)
    }
    
    // MARK: TextField Switcher
    private var textEditor: some View {
        VStack(alignment: .leading) {
            switch selectedOption {
            case 1:
                titleAndWordCount("Text Snippet", viewModel.textSnippet.count, 400)
                CustomDivider()
                TextEditor(text: $viewModel.textSnippet)
                    .keyboardShortcut(.cancelAction)
                
            case 2:
                titleAndWordCount("Code Block", viewModel.codeBlock.count, 400)
                CustomDivider()
                TextEditor(text: $viewModel.codeBlock)
                    .font(.system(size: 14, design: .monospaced))
            case 3:
                titleAndWordCount("Tags",0, 10)
                CustomDivider()
                textFieldsForTags
            case 4:
                titleAndWordCount("URL",viewModel.url.count, 50)
                CustomDivider()
                TextEditor(text: $viewModel.url)
                
            default:
                TextEditor(text: $viewModel.textSnippet)
            }
            publishButton
                .padding(.bottom, 7)
        }
        .padding(.horizontal, 7)
        .font(.poppins(.regular, 14))
        .foregroundColor(.theme.secondaryTitle)
        .textEditorStyle()
    }
    
    // MARK: Tags Fields
    private var textFieldsForTags: some View {
        // Refrence: https://stackoverflow.com/questions/67548007/using-textfield-with-foreach-in-swiftui
        VStack(spacing: 13) {
            ScrollView {
                ForEach(viewModel.tags.indices, id: \.self) { tag in
                    TextField(
                        "#tag\(tag+1)",
                        text:  Binding<String>(get: {
                            if viewModel.tags.indices.contains(tag) {
                                return viewModel.tags[tag]
                            } else {
                                return ""
                            }
                        }, set: { newValue in
                            viewModel.tags[tag] = newValue
                        })
                    )
                    CustomDivider()
                    .padding(7)
                }
            }
            Spacer()
        }
    }
    
    // MARK: Visibility
    private var visibility: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Post Visibility")
                .font(.poppins(.medium, 14))
                .padding(.horizontal, 6)
            
            postAnonymous
        }
    }
    
    // MARK: Anonymous Toogle Switch
    private var postAnonymous: some View {
        Button {
            withAnimation {
                viewModel.isPostAnonymous.toggle()
            }
            HapticManager.light()
        } label: {
            Image("anonymousIcon")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(
                    viewModel.isPostAnonymous ? .theme.inverseTitle : .theme.primaryTitle)
                .circularButton(
                    frameSize: 35,
                    bgColor: viewModel.isPostAnonymous ? .theme.inverseBackground : nil)
                .padding(.trailing, 5)
        }
    }
    
    // MARK: Post Tools
    private var postTools: some View {
        SegmentedControlView(
            tabs: postOptions, showText: true,
            selectedTab: $selectedOption,
            height: 40, cornerRadius: 18
        )
        .padding(.horizontal, 2)
    }
    
    private func titleAndWordCount(_ title: String, _ count: Int, _ limit: Int) -> some View{
        HStack {
            Text(title)
            Spacer()
            Text("\(count)/\(limit)")
                .font(.poppins(.regular, 12))
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
            .sheet(isPresented: .constant(true)) {
                CreatePostView(postType: .newPost, post: Debugging.debuggingPostContent)
                    .preferredColorScheme(.dark)
            }
            .environmentObject(AuthenticationViewModel())
    }
}

