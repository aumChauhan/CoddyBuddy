import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct PostQuestionDataModel_Sync {
    
    func uploadQuestion(query: String, codeBlock: String?, isUploadedSuccessfully: @escaping(Bool) -> Void) {
        
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let QueryPostDataDictionary = [
            "uid": userUID,
            "query": query,
            "codeBlock": codeBlock ?? "",
            "likes": 0,
            "comments": 0,
            "QueryPostedOn": Timestamp(date: Date())
        ] as [String: Any]
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery").document()
                .setData(QueryPostDataDictionary) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        isUploadedSuccessfully(false)
                        return
                    } else {
                        isUploadedSuccessfully(true)
                    }
                }
        }
    }
    
    func postQuery(completion: @escaping([PostedQuery_MetaData]) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery")
                .order(by: "QueryPostedOn", descending: true)
                .getDocuments { downloaded, _ in
                    guard let docs = downloaded?.documents else { return }
                    let posts = docs.compactMap( { try? $0.data(as: PostedQuery_MetaData.self) })
                    completion(posts)
                }
        }
    }
    
    func fetchPostQuery_UserProfile(forUUID uid: String, completion: @escaping([PostedQuery_MetaData]) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery")
                .whereField("uid", isEqualTo: uid)
                .getDocuments { downloaded, _ in
                    guard let docs = downloaded?.documents else { return }
                    let posts = docs.compactMap( { try? $0.data(as: PostedQuery_MetaData.self) })
                    completion(posts.sorted(by: { PostedQuery_MetaData1, PostedQuery_MetaData2 in
                        PostedQuery_MetaData1.QueryPostedOn.dateValue() > PostedQuery_MetaData2.QueryPostedOn.dateValue()
                    }))
                }
        }
    }
    
    func likePost(_ post: PostedQuery_MetaData, completionHandler: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postID = post.id else { return }
        let userLikeReference = Firestore.firestore().collection("registeredUserData").document(uid).collection("User_Liked_Questions")
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery").document(postID)
                .updateData(["likes" : post.likes + 1]) { _ in
                    userLikeReference.document(postID).setData([:]) { _ in
                        completionHandler()
                    }
                }
        }
    }
    
    func isLiked(_ post: PostedQuery_MetaData, completionHandler: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postID = post.id else { return }
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("registeredUserData").document(uid).collection("User_Liked_Questions")
                .document(postID).getDocument { snapshot, _  in
                    guard let snapshot = snapshot else { return }
                    completionHandler(snapshot.exists)
                }
        }
    }
    
    func dissLikePost(_ post: PostedQuery_MetaData, completionHandler: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postID = post.id else { return }
        let userLikeReference = Firestore.firestore().collection("registeredUserData").document(uid).collection("User_Liked_Questions")
        guard post.likes > 0 else { return }
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("UserQuery").document(postID)
                .updateData(["likes" : post.likes - 1]) { _ in
                    userLikeReference.document(postID).delete { _ in
                        completionHandler()
                    }
                }
        }
    }
    
    func fetchLikedQuestion_UserProfile(forUID uid: String, completion: @escaping([PostedQuery_MetaData]) -> Void ) {
        var postsUser = [PostedQuery_MetaData]()
        Firestore.firestore().collection("registeredUserData").document(uid).collection("User_Liked_Questions")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                documents.forEach { doc in
                    let postID = doc.documentID
                    
                    Firestore.firestore().collection("UserQuery").document(postID)
                        .getDocument { snapshot, _ in
                            guard let post = try? snapshot?.data(as: PostedQuery_MetaData.self) else { return }
                            postsUser.append(post)
                            completion(postsUser)
                        }
                }
            }
    }
}

