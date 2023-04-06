import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class PostQueryViewModel: ObservableObject {
    
    let objFor_PostQuestionDataModel_Sync = PostQuestionDataModel_Sync()
    @Published var isQueryPosted: Bool = false
    @Published var isDeleted: Bool = false
    @Published var revokeAlert: Bool = false
    @Published var recallFunction: Bool = false
    
    func postQueryDB(withQuery query: String, codeBlock: String) {
        objFor_PostQuestionDataModel_Sync.uploadQuestion(query: query, codeBlock: codeBlock) { isPosted in
            if isPosted {
                withAnimation {
                    self.isQueryPosted = true
                }
            } else {
                withAnimation {
                    self.isQueryPosted = false
                }
            }
        }
    }
    
    func deleteQuery(Post: PostedQuery_MetaData) {
        Firestore.firestore().collection("UserQuery").document(Post.id ?? "").delete { error in
            if let error = error {
                print(error.localizedDescription)
                withAnimation {
                    self.isDeleted = false
                }
            } else  {
                self.isDeleted = true
                withAnimation {
                    self.isDeleted = false
                    self.revokeAlert = false
                }
            }
        }
    }
}
