import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct Report_Post_DataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var reportedPost_Content: PostedQuery_MetaData?
    var reportedPost_CodeBlock: PostedQuery_MetaData?
    var reportedPost_ID: String
    var who_Reported_Name: String
}
