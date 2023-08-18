//  PostModel.swift
//  Created by Aum Chauhan on 18/07/23.

import Foundation
import Firebase

struct PostModel: Codable, Hashable {
    var postOwnerUID: String
    var postUID: String
    var postedOnDate: Date
    var postSearchKeywords: [String]
    var postContent: PostContentModel
    var postAnalytics: PostAnalytics
    
    init(postOwnerUID: String, postUID: String, postedOnDate: Date, postSearchKeywords: [String], postContent: PostContentModel, postAnalytics: PostAnalytics) {
        self.postOwnerUID = postOwnerUID
        self.postUID = postUID
        self.postedOnDate = postedOnDate
        self.postSearchKeywords = postSearchKeywords
        self.postContent = postContent
        self.postAnalytics = postAnalytics
    }
}

// MARK: Coding Keys
struct PostModelKeys {
   static let postOwnerUID = "postOwnerUID"
   static let postUID = "postUID"
   static let postedOnDate = "postedOnDate"
   static let postSearchKeywords = "postSearchKeywords"
   static let postContent = "postContent"
   static let postAnalytics = "postAnalytics"
}

// MARK: Sub Model For `PostModel`
struct PostContentModel: Codable, Hashable {
    var textSnippet: String
    var codeBlock: String
    var urlString: String
    var tags: [String]
    
}

// MARK: Coding Keys
struct PostContentKeys {
   static let textSnippet = "textSnippet"
   static let codeBlock = "codeBlock"
   static let urlString = "urlString"
   static let tags = "tags"
}

// MARK: Sub Model For `PostModel`
struct PostAnalytics: Codable, Hashable {
    var postAnonymously: Bool
    var views: Int
    var likeCount: Int
    var repliesCount: Int
    var viewedBy: [String]
    
    init(postAnonymously: Bool) {
        self.postAnonymously = postAnonymously
        self.likeCount = 0
        self.views = 0
        self.repliesCount = 0
        self.viewedBy = []
    }
}

// Coding Keys
struct PostAnalyticsKeys {
   static let postAnonymously = "postAnonymously"
   static let views = "views"
   static let likeCount = "likeCount"
   static let repliesCount = "repliesCount"
   static let viewedBy = "viewedBy"
}


