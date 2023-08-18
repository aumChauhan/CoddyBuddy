//  Debugging.swift
//  Created by Aum Chauhan on 17/07/23.

import Foundation

class Debugging {
    private init() { }
    
    static let debuggingPostContent = PostModel(
        postOwnerUID: "fdsjhfbjahsbhdsbf",
        postUID: "dhgfuysdgi",
        postedOnDate: Date(),
        postSearchKeywords: ["Hello"],
        postContent: PostContentModel(
            textSnippet: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
            codeBlock: """
            function adipiscing(elit) {
              if (!elit.sit) {
                return [];
              }
              const sed = elit[0];
              return eiusmod;
            }
            """,
            urlString: "https://google.com",
            tags: ["swift", "ios", "wwdc2023", "", ""]
        ),
        postAnalytics: PostAnalytics(postAnonymously: false))
    
    static let debuggingPostContent2 = PostModel(
        postOwnerUID: "fdsjhfbjahsbhdsbf",
        postUID: "dhgfuysdgi",
        postedOnDate: Date(),
        postSearchKeywords: ["Hello"],
        postContent: PostContentModel(
            textSnippet: "New",
            codeBlock: "",
            urlString: "",
            tags: ["", "", "", "", ""]
        ),
        postAnalytics: PostAnalytics(postAnonymously: false))
    
    static let debuggingReplyContent = ReplyPostDataModel(
        replyToPostUID: "736487y38572",
        replyToPostOwnersUID: "jdshfivhsdifuh;sdihf",
        postOwnerUID: "dsiofuhiusdhfius",
        postUID: "djnfdsfdsf",
        postContent:  PostContentModel(
            textSnippet: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
            codeBlock: """
            function adipiscing(elit) {
              if (!elit.sit) {
                return [];
              }
              const sed = elit[0];
              return eiusmod;
            }
            """,
            urlString: "https://google.com",
            tags: ["swift", "ios", "wwdc2023", "", ""]
        ),
        postAnalytics: PostAnalytics(postAnonymously: false))
    
    static let debuugingProfile = UserProfileModel(
        userUID: "9b7SEudYSbR7lOpEt5rEQmY3EAC2",
        fullName: "Tim Cook",
        userName: "tim_cook",
        emailId: "timcook@coddybuddy.com",
        profilePicURL: "https://firebasestorage.googleapis.com:443/v0/b/coddybuddyfirebase.appspot.com/o/ProfilePhotos%2FA9B1AC14-3C27-43FF-A30F-E3B99D916829.jpeg?alt=media&token=571b5df1-c5fd-4076-8c9e-ae4f1a55c8fa",
        isVerified: true,
        isPrivateAccount: false, joinedOn: Date(),
        deviceDetails: DeviceDetails(),
        userActivities: UserActivityDataModel()
    )
    
    static let debuggingChatRoom = ChatRoomModel(
        createdBy: "Aum Chauhan",
        createdOn: Date(),
        chatRoomName: "Swift",
        memberCount: 10,
        chatRoomDescription: "Lorem Ipsum, Some Details regarding chat room will be shown here  so it will make easy to see user.", membersUIDs: [], chatRoomColorPalette: "ColorBlue",
        chatRoomProfileURLString: ""
    )
    
    static let debuggingMessageContent = ChatRoomMessagesModel(id: "iueh", senderUID: "hgdyuwegduyewgdiu", sentAt: Date(), messageUID: "sdicuygdsigi", textSinppet: "Here the message of sender will hr printed.", codeBlock: "Here the message of sender will hr printed.", url: "www.apple.in")
    
}
