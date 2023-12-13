//  RepliesViewModel.swift
//  Created by Aum Chauhan on 30/07/23.

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class RepliesViewModel: ObservableObject {
    
    let userUID = Auth.auth().currentUser?.uid ?? "nil"
    private let postService = PostService()
    private let service = ReplyService()
    
    var lastSnapDoc: DocumentSnapshot? = nil
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    @Published var postListner: ReplyPostDataModel? = nil
    @Published var allPosts: [ReplyPostDataModel] = []
    
    
    func fetchPosts(fromPostUID: String, emptyPosts: Bool) async {
        do {
            if emptyPosts {
                allPosts = []
                lastSnapDoc = nil
            }
            let (posts, lastDoc) = try await service.fetchReplies(fromPostUID: fromPostUID, lastDocument: lastSnapDoc)
            
            withAnimation {
                self.allPosts.append(contentsOf: posts.lazy)
                lastSnapDoc = lastDoc
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func replyListner(replyToUID: String, replyUID: String) {
        FSCollections.posts.document(replyToUID).collection(FSCollections.replies).document(replyUID)
            .addSnapshotListener { [weak self] snapShot , error in
                withAnimation {
                    self?.postListner = try? snapShot?.data(as: ReplyPostDataModel.self)
                }
            }
    }
    
    func likePost(post: PostModel, reply: ReplyPostDataModel) async {
        do {
            HapticManager.soft()
            try await service.likePost(post: post, reply: reply, userUID: userUID)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func removeFromLike(post: PostModel, reply: ReplyPostDataModel) async {
        do {
            HapticManager.soft()
            try await service.removeFromLike(post: post, reply: reply, userUID: userUID)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func deleteReplyFromPost(repliedTo: String, replyUID: String) async {
        do {
            try await service.deleteReply(repliedTo: repliedTo, replyUID: replyUID)
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func reportReply(reply: ReplyPostDataModel) async {
        do {
            try await service.reportReply(reply: reply)
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
