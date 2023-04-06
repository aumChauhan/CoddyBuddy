import Foundation
import FirebaseCore
import FirebaseFirestore

struct DebuggingCoddyBuddy_Model: Identifiable {
    let id: String
    var inDevelopment: Bool
}

class DebuggingCoddyBuddy: ObservableObject {
    init() {
        get_DevelopmentState()
    }
    
    @Published var CoddyBuddy_In_Development: Bool = false
    @Published var developerName: String = ""
    @Published var developerPassword: String = ""
    
    func get_DevelopmentState() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("Debugging").document("DevelopmentStatus")
        
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.CoddyBuddy_In_Development = data["inDevelopment"] as? Bool ?? false
                    self.developerName = data["developerName"] as? String ?? ""
                    self.developerPassword = data["developerPassword"] as? String ?? ""
                }
            }
            
        }
    }
}


struct Recommendation_Model: Identifiable {
    let id: String
    let Ad1_URL: String
    let Ad2_URL: String
    let Ad3_URL: String
}

class Recommendation_VM: ObservableObject {
    
    @Published var Ad1_URL: String = ""
    @Published var Ad2_URL: String = ""
    @Published var Ad3_URL: String = ""
    
    init() {
        get_RecommendationURL()
    }
    
    func get_RecommendationURL() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("Recommendation").document("Recommendation_Posts")
        
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.Ad1_URL = data["Ad1"] as? String ?? ""
                    self.Ad2_URL = data["Ad2"] as? String ?? ""
                    self.Ad3_URL = data["Ad3"] as? String ?? ""
                }
            }
            
        }
    }
}
