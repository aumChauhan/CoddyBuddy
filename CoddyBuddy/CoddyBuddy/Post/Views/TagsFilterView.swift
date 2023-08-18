//  TagsFilterView.swift
//  Created by Aum Chauhan on 26/07/23.

import SwiftUI

struct TagsFilterView: View {
    
    let tag: String
    
    @StateObject private var viewModel = TagsViewModel()
    
    var body: some View {
        NavigationHeaderView(title: "#\(tag)") {
            posts
        } topLeading: {
            DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
        } topTrailing: {
            Circle().frame(width: iconHeight).opacity(0.0)
        } subHeader: {
            postCount
        }
        .onFirstAppear {
            Task {
                // MARK: Initial Fetch Request
                await viewModel.fetchPosts(tag: tag)
                // MARK: Fetch Post Count
                await viewModel.getPostCountForTags(tag: tag)
            }
        }
        .navigationBarHidden(true)
    }
}

extension TagsFilterView {
    
    // MARK: Count Posts
    private var postCount: some View {
        HStack {
            Image("message")
            Text("\(viewModel.postCount) Posts")
        }
        .foregroundColor(.theme.inverseTitle)
        .font(.poppins(.semiBold, 16))
        .padding(15)
        .dynamicBgFill(height: 45, bgColor: .theme.inverseBackground)
    }
    
    // MARK: Posts
    private var posts: some View {
        LazyVStack(spacing: 15) {
            ForEach(viewModel.allPostsWithTags, id: \.self) { post in
                
                CustomDivider()
                
                PostCardView(postContent: post, postOwnerUID: post.postOwnerUID, postType: .newPost)
                
                if (post == viewModel.allPostsWithTags.last && viewModel.lastSnapDoc != nil) {
                    // MARK: Appending Posts
                    ProgressView()
                        .task {
                            await viewModel.fetchPosts(tag: tag)
                        }
                }
            }
            CustomDivider()
        }
    }
}

struct TagsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        TagsFilterView(tag: "Swift")
    }
}
