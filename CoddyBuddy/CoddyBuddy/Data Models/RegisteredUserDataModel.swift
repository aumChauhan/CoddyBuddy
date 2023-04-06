import Foundation
import UIKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct RegisteredUserDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var isVerfied: Bool
    var showProfilePic: Bool = true
    var anonymousName: Bool = false
    var anonymousUserName: Bool = false
    let email: String
    var randomColorProfile: String
    let fullName: String
    let userName: String
    let profilePicURL: String
    let joinedOn: Timestamp
    var deviceName: String = UIDevice.current.name
    var deviceModel: String = UIDevice.current.model
    var deviceSystemName: String = UIDevice.current.systemName
    var deviceSystemVersion: String = UIDevice.current.systemVersion
}
