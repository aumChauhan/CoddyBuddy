import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ExploreSection_ViewModel : ObservableObject {
    
    @Published var allUserFetch = [RegisteredUserDataModel]()
    @Published var search_textfield: String = ""
    
    var filteredUser: [RegisteredUserDataModel] {
        let searchFieldLowerCased = search_textfield.lowercased()
        return allUserFetch.filter { dataIndex in
            dataIndex.userName.contains(searchFieldLowerCased)
            || dataIndex.fullName.lowercased().contains(searchFieldLowerCased)
        }
    }
    
    var verfiedUser: [RegisteredUserDataModel] {
        return allUserFetch.filter { index in
            index.isVerfied
        }
    }
    
    init() {
        fetchAllUserData()
    }
    
    func fetchAllUserData() {
        let dbReference = Firestore.firestore()
        
        dbReference.collection("registeredUserData")
            .getDocuments { [weak self] dataDownload, error in
                if error == nil {
                    if let dataDownload = dataDownload {
                        DispatchQueue.main.async {
                            self?.allUserFetch = dataDownload.documents.map { data in
                                return RegisteredUserDataModel(
                                    id: data.documentID,
                                    isVerfied: data["isVerfied"] as? Bool ?? false,
                                    email: data["email"] as? String ?? "",
                                    randomColorProfile: data["randomColorProfile"] as? String ?? "",
                                    fullName: data["fullName"] as? String ?? "",
                                    userName: data["userName"] as? String ?? "",
                                    profilePicURL: data["profilePicURL"] as? String ?? "",
                                    joinedOn: data["joinedOn"] as? Timestamp ?? Timestamp(date: Date()))
                            }
                        }
                        
                    }
                }
            }
    }
}
