import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct fetchUserServiceViewModel {
    
    func fetchUserData(withuid uid: String, completion: @escaping (RegisteredUserDataModel) -> () ) {
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("registeredUserData").document(uid)
                .getDocument {  dataDownloaded, _ in
                    guard let dataDownloaded = dataDownloaded else { return }
                    guard let users = try? dataDownloaded.data(as: RegisteredUserDataModel.self) else { return }
                    completion(users)
                }
        }
    }
}
