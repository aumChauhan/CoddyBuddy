//  ChatRoomDataModel.swift
//  Created by Aum Chauhan on 22/07/23.

import SwiftUI
import Foundation
import Firebase

struct ChatRoomModel: Codable, Hashable {
    let createdBy: String
    let createdOn: Date
    let chatRoomName: String
    let memberCount: Int
    let chatRoomDescription: String
    let membersUIDs: [String]
    let chatRoomColorPalette: String
    let chatRoomProfileURLString: String
}

// Coding Keys
struct ChatRoomModelKeys {
    static let createdBy = "createdBy"
    static let createdOn = "createdOn"
    static let chatRoomName = "chatRoomName"
    static let memberCount = "memberCount"
    static let membersUID = "membersUIDs"
    static let chatRoomDescription = "chatRoomDescription"
    static let chatRoomColorPalette = "chatRoomColorPalette"
    static let chatRoomProfileURLString = "chatRoomProfileURLString"
}


// MARK: For Chat Room Messages
struct ChatRoomMessagesModel: Codable, Hashable {
    let id: String
    let senderUID: String
    let sentAt: Date
    let messageUID: String
    let textSinppet: String
    let codeBlock: String
    let url: String
}

// Coding Keys

struct ChatRoomMessageModelKey {
    static let senderUID = "senderUID"
    static let sentAt = "sentAt"
    static let messageUID = "messageUID"
    static let textSinppet = "textSinppet"
    static let codeBlock = "codeBlock"
    static let url = "url"
}

