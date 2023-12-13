//  UserProfileDataModel.swift
//  Created by Aum Chauhan on 17/07/23.

import Foundation
import UIKit
import Firebase
import FirebaseAuth

struct UserProfileModel: Codable, Hashable {
    let userUID: String
    let fullName: String
    let userName: String
    let emailId: String
    let profilePicURL: String?
    let isVerified: Bool?
    let isPrivateAccount: Bool?
    let joinedOn: Date
    let deviceDetails: DeviceDetails
    let userActivities: UserActivityDataModel
    
    // MARK: For SignIn With Email
    init(withEmail currentUser: User, fullName: String, userName: String) {
        self.userUID = currentUser.uid
        self.fullName = fullName
        self.userName = userName
        self.emailId = currentUser.email ?? ""
        self.profilePicURL = ""
        self.isVerified = false
        self.isPrivateAccount = false
        self.joinedOn = Date()
        self.deviceDetails = DeviceDetails()
        self.userActivities = UserActivityDataModel()
    }
    
    // MARK: For Continue With Google
    init(withGoogle currentUser: User) {
        self.userUID = currentUser.uid
        self.fullName = currentUser.displayName ?? ""
        self.emailId = currentUser.email ?? ""
        self.profilePicURL = currentUser.photoURL?.absoluteString ?? ""
        self.isVerified = false
        self.isPrivateAccount = false
        self.joinedOn = Date()
        self.deviceDetails = DeviceDetails()
        self.userActivities = UserActivityDataModel()
        self.userName = ValidationService.generateUerName(from: emailId) ?? "userName"
    }
    
    init(userUID: String, fullName: String, userName: String, emailId: String, profilePicURL: String, isVerified: Bool, isPrivateAccount: Bool, joinedOn: Date, deviceDetails: DeviceDetails, userActivities: UserActivityDataModel) {
        self.userUID = userUID
        self.fullName = fullName
        self.userName = userName
        self.emailId = emailId
        self.profilePicURL = profilePicURL
        self.isVerified = isVerified
        self.isPrivateAccount = isPrivateAccount
        self.joinedOn = joinedOn
        self.deviceDetails = deviceDetails
        self.userActivities = userActivities
    }
}

struct UserModelKeys {
   static let userUID = "userUID"
   static let fullName = "fullName"
   static let userName = "userName"
   static let emailId = "emailId"
   static let profilePicURL = "profilePicURL"
   static let isVerified = "isVerified"
   static let isPrivateAccount = "isPrivateAccount"
   static let joinedOn = "joinedOn"
   static let deviceDetails = "deviceDetails"
   static let userActivities = "userActivities"
}

// MARK: Sub Model For `UserProfileModels`
struct DeviceDetails: Codable , Hashable {
    let model: String
    let deviceName: String
    let systemName: String
    let systemVersion: String
    
    init() {
        self.model = UIDevice.current.model
        self.deviceName = UIDevice.current.name
        self.systemName = UIDevice.current.systemName
        self.systemVersion = UIDevice.current.systemVersion
    }
}

// MARK: Sub Model For `UserProfileModels`
struct UserActivityDataModel: Codable, Hashable {
    let likedPostsId: [String]
    let followersUID: [String]
    let followingsUID: [String]
    let followingCount: Int
    let followerCount: Int
    let joinedChatRooms: [String]
    let postCount: Int
    
    init() {
        self.likedPostsId = []
        self.followersUID = []
        self.followingsUID = []
        self.followingCount = 0
        self.followerCount = 0
        self.joinedChatRooms = []
        self.postCount = 0
    }
}

struct UserActivityKey {
   static let likedPostsId = "likedPostsId"
   static let followersUID = "followersUID"
   static let followingsUID = "followingsUID"
   static let followerCount = "followerCount"
   static let followingCount = "followingCount"
   static let joinedChatRooms = "joinedChatRooms"
   static let postCount = "postCount"
}
