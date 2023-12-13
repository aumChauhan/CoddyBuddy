//  PostViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift

enum PostType: String {
    case newPost = "Create Post"
    case reply = "Reply"
    case tags = "Tags"
}

@MainActor
class PostViewModel: ObservableObject {
    
    private let service = PostService()
    private let replyService = ReplyService()
    
    let userUID = Auth.auth().currentUser?.uid ?? "nil"
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    @Published var textSnippet: String = ""
    @Published var codeBlock: String = ""
    @Published var url: String = ""
    @Published var tags: [String] = ["","","","",""]
    @Published var isPostAnonymous: Bool = false
    
    @Published var postPublishedStatus: Bool = false
    @Published var postOwnerInfo: UserProfileModel? = nil
    
    @Published var postListner: PostModel? = nil
    
    
    func publishPost(postType: PostType,replyToPostUID: String, replyToPostOwnersUID: String) async {
        do {
            guard ValidationService.validateTextFields(textSnippet) else {
                throw ValidationError.noCharacterFound
            }
            
            guard ValidationService.isValidURL(url) else {
                throw ValidationError.invalidURLFormat
            }
            
            guard ValidationService.hasUniqueTag(tags) else {
                throw ValidationError.noUniqueTagError
            }
            
            guard textSnippet.count < 400 else {
                throw ValidationError.textSnippetLimitExceeds
            }
            
            guard codeBlock.count < 400 else {
                throw ValidationError.codeBlockLimitExceeds
            }
            
            for eachTags in tags {
                guard eachTags.count < 14 else {
                    throw ValidationError.tagLimitExceeds
                }
            }
            guard url.count < 50 else {
                throw ValidationError.urlLimitExceeds
            }
            
            if postType == .newPost {
                try await service.publishPost(
                    textSnippet: textSnippet.trimmingCharacters(in: .whitespacesAndNewlines),
                    codeBlock: codeBlock.trimmingCharacters(in: .whitespacesAndNewlines),
                    urlString: url.trimmingCharacters(in: .whitespacesAndNewlines),
                    tags: tags,
                    isPostAnonymous: isPostAnonymous
                )
                postPublishedStatus.toggle()
            } else {
                try await replyService.publishReply(
                    replyToPostUID: replyToPostUID,
                    replyToPostOwnersUID: replyToPostOwnersUID,
                    textSnippet: textSnippet.trimmingCharacters(in: .whitespacesAndNewlines),
                    codeBlock: codeBlock.trimmingCharacters(in: .whitespacesAndNewlines),
                    urlString: url.trimmingCharacters(in: .whitespacesAndNewlines),
                    tags: tags,
                    isPostAnonymous: isPostAnonymous
                )
                postPublishedStatus.toggle()
            }
            
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }

    func deletePost(postId: String) async {
        do {
            try await service.deletePost(postUID: postId)
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func attachListnerToPostInteraction(postUID: String) {
        FSCollections.posts.document(postUID)
            .addSnapshotListener { snapShot , error in
                let decodedPost = try? snapShot?.data(as: PostModel.self)
                self.postListner = decodedPost
            }
    }
    
    func fetchPostOwnerInfo(userUID: String) async {
        do {
            let tempOwnerInfo = try await service.getPostOwnersInfo(userUID: userUID)
            withAnimation {
                postOwnerInfo = tempOwnerInfo
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func likePost(post: PostModel) async {
        do {
            HapticManager.soft()
            try await service.likePost(post: post, userUID: userUID)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func removeFromLike(post: PostModel) async {
        do {
            HapticManager.soft()
            try await service.removeFromLike(post: post, userUID: userUID)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func updateViewCountToPost(post: PostModel) async {
        try? await service.updateViews(post: post)
    }
    
    func sentReport(post: PostModel) async {
        do {
            try await service.reportPosts(post: post)
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        HapticManager.error()
    }
}

