//  ReplyService.swift
//  Created by Aum Chauhan on 30/07/23.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

actor ReplyService {
    
    private let postService = PostService()
    
    /// Appends Reply (To Post Document's Sub Collection i.e, Replies).
    func publishReply(replyToPostUID: String, replyToPostOwnersUID: String, textSnippet: String, codeBlock: String, urlString: String, tags: [String], isPostAnonymous: Bool) async throws {
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userCancelledAuthentication)
        }
        
        // Creates Blank Document With UID
        // POST REQUEST
        let document = FSCollections.posts.document(replyToPostUID).collection(FSCollections.replies).document()
        // Post UID
        let postDocID = document.documentID
        
        // Reply Data Initializing
        let postDataModel = ReplyPostDataModel(
            replyToPostUID: replyToPostUID,
            replyToPostOwnersUID: replyToPostOwnersUID,
            postOwnerUID: userUID,
            postUID: postDocID,
            // Content
            postContent: PostContentModel(
                textSnippet: textSnippet,
                codeBlock: codeBlock,
                urlString: urlString,
                tags: tags
            ),
            // Analytics
            postAnalytics: PostAnalytics(postAnonymously: isPostAnonymous)
        )
        
        // PUT REQUEST
        try document.setData(from: postDataModel)
        
        // If Post Is !Anonymous Then Storing PostUID Into UserProfile
        if !isPostAnonymous {
            let collectionReference = FSCollections.userProfile.document(userUID).collection(FSCollections.userReplies)
            
            // POST REQUEST
            try await collectionReference.document(postDocID).setData([:])
        }
        
        // Creating Tags Collection (From `[tags]`)
        for eachTag in tags {
            if eachTag != "" {
                // POST REQUEST
                try await FSCollections.tags.document(eachTag)
                    .collection(FSCollections.postUIDs).document(postDataModel.replyToPostUID)
                    .collection(FSCollections.replies).document(postDataModel.postUID)
                    .setData([:])
                
                // Appending Posts Count In Tag Doc
                let postCount = try await postService.getPostCount(for: eachTag)
                
                // PATCH REQUEST
                try FSCollections.tags.document(eachTag).setData(
                    from: TagModel(tagName: eachTag, postCount: postCount),
                    merge: false)
            }
        }
        
        // Updating Comments Count
        // PATCH REQUEST
        let commentsCount = await getRepliesCount(for: replyToPostUID) ?? 0
        
        try await FSCollections.posts.document(replyToPostUID).updateData([
            "\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.repliesCount)" : commentsCount
        ])
    }
    
    /// - Fetch Posts (From Post.Replies Collection And Tag Collection) Without Listner
    /// - Returns : `([ReplyPostDataModel], DocumentSnapshot?)`
    func fetchReplies(fromPostUID: String, lastDocument: DocumentSnapshot?) async throws -> ([ReplyPostDataModel], DocumentSnapshot?) {
        // Post Collection Query
        let collectionReference = FSCollections.posts.document(fromPostUID).collection(FSCollections.replies)
            .order(by: PostModelKeys.postedOnDate, descending: true)
        
        if let lastDocument {
            // Paginating to `[ReplyPostDataModel]`
            // GET REQUEST
            return try await collectionReference
                .start(afterDocument: lastDocument)
                .limit(to: 6)
                .getDocumentWithLastDocuments(as: ReplyPostDataModel.self)
        }
        else {
            // Initial Request
            // GET REQUEST
            return try await collectionReference
                .limit(to: 5)
                .getDocumentWithLastDocuments(as: ReplyPostDataModel.self)
        }
    }
    
    /// - Appends PostUID To PostAnalytics & UserActivities (For Like).
    func likePost(post: PostModel, reply: ReplyPostDataModel, userUID: String) async throws {
        // Appending PostUID To (LikedBy Collection)
        let likedByRef = FSCollections.posts.document(post.postUID)
            .collection(FSCollections.replies).document(reply.postUID)
            .collection(FSCollections.likedBy)
        
        // POST REQUEST
        try await likedByRef.document(userUID).setData([:])
        
        // Updating Likes Count on (PostAnalytics Field)
        let likeCount = try await likedByRef.aggregateCount()
        
        let postData: [String: Any] = [
            "\(ReplyPostModelKeys.postAnalytics).\(PostAnalyticsKeys.likeCount)" : likeCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.posts.document(post.postUID)
            .collection(FSCollections.replies).document(reply.postUID).updateData(postData)
        
        // Appending PostUID To UserActivities Field
        let data: [String: Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.likedPostsId)" : FieldValue.arrayUnion([reply.postUID])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    /// - Removes PostUID To PostAnalytics & UserActivities.
    func removeFromLike(post: PostModel, reply: ReplyPostDataModel, userUID: String) async throws {
        // Removing PostUID To (LikedBy Collection)
        let likedByRef = FSCollections.posts.document(post.postUID)
            .collection(FSCollections.replies).document(reply.postUID)
            .collection(FSCollections.likedBy)
        
        // DELETE REQUEST
        try await likedByRef.document(userUID).delete()
        
        let likeCount = try await likedByRef.aggregateCount()
        
        // Updating Likes Count on (PostAnalytics Field)
        let postData: [String: Any] = [
            "\(ReplyPostModelKeys.postAnalytics).\(PostAnalyticsKeys.likeCount)" : likeCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.posts.document(post.postUID)
            .collection(FSCollections.replies).document(reply.postUID).updateData(postData)
        
        // Removing Post UID To UserActivities Field
        let data: [String: Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.likedPostsId)" : FieldValue.arrayRemove([reply.postUID])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    /// - Delete Reply & Its Refernce From Posts ANd User Profile.
    func deleteReply(repliedTo: String, replyUID: String) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userCancelledAuthentication)
        }
        
        // Delete From Post's Replies Collections
        try await FSCollections.posts.document(repliedTo).collection(FSCollections.replies).document(replyUID).delete()
        
        // Removing Refernce From
        try await FSCollections.userProfile.document(userUID).collection(FSCollections.userReplies).document(replyUID).delete()
    }
    
    /// - Uploads Reply Content To Report Collection
    func reportReply(reply: ReplyPostDataModel) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let report = ReportReplyModel(
            replyUID: reply.postUID,
            replyToPostUID: reply.replyToPostUID,
            replyOwnerUID: reply.postOwnerUID,
            replyTextSnippet: reply.postContent.textSnippet,
            replyCodeBlock: reply.postContent.codeBlock,
            replyTags: reply.postContent.tags,
            replyURL: reply.postContent.urlString,
            reportedBy: userUID)
        
        // POST REQUEST
        try FSCollections.reports.document().setData(from: report)
    }
    
    /// - Fetch Total Number Of Replies On Post (From Posts Collection).
    func getRepliesCount(for postUID: String) async -> Int?  {
        // GET REQUEST
        return try? await FSCollections.posts.document(postUID).collection(FSCollections.replies).aggregateCount()
    }
}
