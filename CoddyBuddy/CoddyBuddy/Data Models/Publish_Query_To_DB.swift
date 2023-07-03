import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostedQuery_MetaData: Identifiable, Codable {
    @DocumentID var id: String?
    let query: String
    let codeBlock: String
    let QueryPostedOn: Timestamp
    var likes: Int
    var comments: Int
    let uid: String
    var user: RegisteredUserDataModel?
    var isLiked: Bool? = false
}
