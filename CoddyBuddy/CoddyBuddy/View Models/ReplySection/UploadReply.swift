import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct UploadReply {
    
    func uploadReply(_ post: PostedQuery_MetaData, reply: String, codeBlock: String?, isUploadedSuccessfully: @escaping(Bool) -> Void) {

        guard let userUID = Auth.auth().currentUser?.uid else { return }
        guard let uName = Auth.auth().currentUser?.email else { return }
        
        let ReplyPostDataDictionary = [
            "uid": userUID,
            "reply": reply,
            "uName": uName,
            "codeBlock": codeBlock ?? "",
            "likes": 0,
            "postId": post.id ?? "",
            "replyPostedOn": Timestamp(date: Date())
        ] as [String: Any]
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery").document(post.id ?? "").collection("User_Reply").document()
                .setData(ReplyPostDataDictionary) { error in
                    if let error = error {
                        isUploadedSuccessfully(false)
                        print(error.localizedDescription)
                        return
                    } else {
                        isUploadedSuccessfully(true)
                    }
                }
        }
    }
    
    
    func postReply_data(_ post: PostedQuery_MetaData?,completion: @escaping([Reply_MetaData]) -> Void ) {
        guard let postID = post?.id else { return }
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery").document(postID).collection("User_Reply")
                .order(by: "replyPostedOn", descending: true)
                .getDocuments { downloaded, _ in
                    guard let docs = downloaded?.documents else { return }
                    
                    let posts = docs.compactMap( { try? $0.data(as: Reply_MetaData.self) })
                    completion(posts)
                }
        }
    }
    
    func fetchPostReply_UserProfile(forUUID uid: String, completion: @escaping([Reply_MetaData]) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery")
                .whereField("uid", isEqualTo: uid)
                .getDocuments { downloaded, _ in
                    guard let docs = downloaded?.documents else { return }
                    let posts = docs.compactMap( { try? $0.data(as: Reply_MetaData.self) })
                    completion(posts.sorted(by: { PostedQuery_MetaData1, PostedQuery_MetaData2 in
                        PostedQuery_MetaData1.replyPostedOn.dateValue() > PostedQuery_MetaData2.replyPostedOn.dateValue()
                    }))
                }
        }
    }
}
