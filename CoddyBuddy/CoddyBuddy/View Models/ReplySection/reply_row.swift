import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class Reply_Feed_SingleRow_ViewModel: ObservableObject {
    private let instancePostSync = UploadReply()
    @Published var postedReply: PostedQuery_MetaData
    
    init (replyPost: PostedQuery_MetaData) {
        self.postedReply = replyPost
    }
}

