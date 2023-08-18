//  Error.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation

// MARK: Error Cases
public enum ValidationError: Error {
    case invalidName
    case invalidUserName
    case userNameAlreadyExists
    
    case noCharacterFound
    case invalidURLFormat
    case noUniqueTagError
    
    case descriptionCantBeEmpty
    case chatRoomAlreadyExists
    case profilePhotoCanntBeNil
    case chatRoomNameLimitExceeds
    case descriptionExceeds
    case descriptionTooSmall
    
    case noFriendsFound
    
    case textSnippetLimitExceeds
    case codeBlockLimitExceeds
    case urlLimitExceeds
    case tagLimitExceeds
}

// FIXME: Modify Error Localized Description
// MARK: Localized Description
extension ValidationError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidName:
            return NSLocalizedString("Name Not Formatted Correctly.", comment: "InvalidName Error")
            
        case .invalidUserName:
            return NSLocalizedString("Username Not Formatted Correctly.", comment: "InvalidUserName Error")
            
        case .userNameAlreadyExists:
            return NSLocalizedString("Username already exists.", comment: "InvalidUserName Error")
            
        case .noCharacterFound:
            return NSLocalizedString("Text snippet must contain at least one character.", comment: "NoCharacterFound Error")
            
        case .invalidURLFormat:
            return NSLocalizedString("Invalid URL format. Please enter a valid HTTP or HTTPS URL.", comment: "InvalidURLFormat Error")
            
        case .noUniqueTagError:
            return NSLocalizedString("Tags contains invalid strings. Each tag should contain only letters and numbers, and tags must be unique.", comment: "NoUniqueTagError Error")
            
        case .descriptionCantBeEmpty:
            return NSLocalizedString("Description cann't be empty.", comment: "DescriptionCantBeEmpty Error")
            
        case .chatRoomAlreadyExists:
            return NSLocalizedString("Chat room already exists.", comment: "ChatRoomAlreadyExists Error")
            
        case .profilePhotoCanntBeNil:
            return NSLocalizedString("Profile photo is mandatory.", comment: "ChatRoomAlreadyExists Error")
            
        case .noFriendsFound:
            return NSLocalizedString("No Friends Found In Followings List.", comment: "noFriendsFound")
            
        case .textSnippetLimitExceeds:
            return NSLocalizedString("Text Snippet Char Count Should Be Less Than 400", comment: "noFriendsFound")
            
        case .codeBlockLimitExceeds:
            return NSLocalizedString("Code Block Char Count Should Be Less Than 400", comment: "noFriendsFound")
            
        case .urlLimitExceeds:
            return NSLocalizedString("Code Block Char Count Should Be Less Than 50", comment: "noFriendsFound")
            
        case .tagLimitExceeds:
            return NSLocalizedString("Each Tag Char Count Should Be Less Than 10", comment: "noFriendsFound")
            
        case .chatRoomNameLimitExceeds:
            return NSLocalizedString("Name Char Count Should Be Less Than 16", comment: "noFriendsFound")
            
        case .descriptionExceeds:
            return NSLocalizedString("Description Char Count Should Be Less Than 30", comment: "noFriendsFound")
            
        case .descriptionTooSmall:
            return NSLocalizedString("Description Char Count Should Be Greater Than 10", comment: "noFriendsFound")
        }
    }
}
