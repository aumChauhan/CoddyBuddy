//  ReportPostModel.swift
//  Created by Aum Chauhan on 12/08/23.

import Foundation

struct ReportPostModel: Codable {
    let postUID: String
    let postOwnerUID: String
    let postTextSnippet: String
    let postCodeBlock: String
    let postTags: [String]
    let postsURL: String
    let reportedBy: String
}

struct ReportReplyModel: Codable {
    let replyUID: String
    let replyToPostUID: String
    let replyOwnerUID: String
    let replyTextSnippet: String
    let replyCodeBlock: String
    let replyTags: [String]
    let replyURL: String
    let reportedBy: String
}
