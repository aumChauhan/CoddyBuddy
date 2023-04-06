import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ReplyAnswerViewModel: ObservableObject {
    
    private let Obj_Upload_reply = UploadReply()
    @Published var isQueryPosted: Bool = false
    @Published var postedQuestion: PostedQuery_MetaData
    
    @Published var isDeleted: Bool = false
    @Published var revokeAlert: Bool = false
    
    init (questionPost: PostedQuery_MetaData) {
        self.postedQuestion = questionPost
    }
    
    func postReplyDB(withReply reply: String, codeBlock: String) {
        Obj_Upload_reply.uploadReply(postedQuestion, reply: reply, codeBlock: codeBlock) {isPosted in
            if isPosted {
                self.isQueryPosted = true
            } else {
                // TODO: THROW ALERT
            }
        }
    }
    
    func deleteReply(Reply: Reply_MetaData) {
        Firestore.firestore().collection("UserQuery").document(Reply.postId).collection("User_Reply").document(Reply.id ?? "").delete { error in
            if let error = error {
                print(error.localizedDescription)
                withAnimation {
                    self.isDeleted = false
                }
            } else  {
                self.isDeleted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        self.isDeleted = false
                        self.revokeAlert = false
                    }
                }
            }
        }
    }
    
}

