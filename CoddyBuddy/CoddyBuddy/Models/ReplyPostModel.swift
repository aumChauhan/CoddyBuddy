//  ReplyPostModel.swift
//  Created by Aum Chauhan on 04/08/23.

import Foundation

struct ReplyPostDataModel: Codable, Hashable {
    var postOwnerUID: String
    var postUID: String
    var postedOnDate: Date
    var postContent: PostContentModel
    var postAnalytics: PostAnalytics
    var replyToPostUID: String
    var replyToPostOwnersUID: String
    
    init(replyToPostUID: String, replyToPostOwnersUID: String, postOwnerUID: String, postUID: String,postContent: PostContentModel, postAnalytics: PostAnalytics) {
        self.postOwnerUID = postOwnerUID
        self.postUID = postUID
        self.postedOnDate = Date()
        self.postContent = postContent
        self.postAnalytics = postAnalytics
        self.replyToPostUID = replyToPostUID
        self.replyToPostOwnersUID = replyToPostOwnersUID
    }
}

struct ReplyPostModelKeys {
   static let postOwnerUID = "postOwnerUID"
   static let postUID = "postUID"
   static let postedOnDate = "postedOnDate"
   static let postContent = "postContent"
   static let postAnalytics = "postAnalytics"
   static let replyToPostUID = "replyToPostUID"
   static let replyToPostOwnersUID = "replyToPostOwnersUID"
}
