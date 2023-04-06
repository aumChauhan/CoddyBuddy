import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserAuthnticateViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var registeredUserProfileView: Bool = false
    @Published var currentUserData: RegisteredUserDataModel?
    
    @Published var signInAlertString: String = ""
    @Published var errorSignINBool: Bool = false
    
    @Published var logInAlertString: String = ""
    @Published var logINDismissSheet: Bool = true
    
    @Published var errorResetString: String = ""
    @Published var errorResetBool: Bool = false
    @Published var NOerrorResetBool: Bool = false
    
    @Published var errorLogInString: String = ""
    @Published var errorLogINBool: Bool = false
    
    var tempSession: FirebaseAuth.User?
    var fetchService = fetchUserServiceViewModel()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUserInfo()
    }
    
    func logInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { userData, error in
            if let error = error {
                self.logInAlertString = error.localizedDescription
                withAnimation {
                    self.errorLogINBool = true
                }
            }
            guard let userDetails =  userData?.user else {  return }
            self.userSession = userDetails
            self.fetchUserInfo()
        }
    }
    
    let ColorThemeArray: [String] = [
        "Theme_Blue", "Theme_Purple", "Theme_Pink","Theme_Orange","Theme_Graphite","Theme_Green","Theme_Red", "Theme_Indigo", "Theme_Brown"
    ]
    
    func SignUpUser(fullName: String, userName: String, email: String,password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { userData, error in
            if let error = error {
                self.signInAlertString = error.localizedDescription
                withAnimation {
                    self.errorSignINBool = true
                }
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            
            guard let userDetails = userData?.user else { return }
            
            self.tempSession = userDetails
            
            let userRegisterationData = [
                "fullName" : fullName.capitalized,
                "userName" : userName.lowercased(),
                "email" : email.lowercased(),
                "joinedOn" : Timestamp(date: Date()),
                "isVerfied": false,
                "showProfilePic": true,
                "anonymousName": false,
                "randomColorProfile": self.ColorThemeArray[Int.random(in: 0..<8)],
                "anonymousUserName": false,
                "deviceName" : UIDevice.current.name,
                "deviceModel" : UIDevice.current.model,
                "deviceSystemName" : UIDevice.current.systemName,
                "deviceSystemVersion" : UIDevice.current.systemVersion
            ]
            
            Firestore.firestore().collection("registeredUserData").document(userDetails.uid)
                .setData(userRegisterationData) { _ in
                    self.registeredUserProfileView = true
                }
        }
    }
    
    //MARK: BUG FIXES NEEDED
    func editUserName(fullName: String) {
        let db = Firestore.firestore()
        db.collection("registeredUserData").document(currentUserData?.id ?? "").setData(["fullName":fullName,])
    }
    
    func logOut() {
        userSession = nil
        try? Auth.auth().signOut()
        self.registeredUserProfileView = false
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempSession?.uid else { return }
        
        UploadImageToDataBase.uploadProfile(image: image) { profilePicURL in
            Firestore.firestore().collection("registeredUserData").document(uid)
                .updateData(["profilePicURL": profilePicURL]) { _ in
                    self.userSession = self.tempSession
                    self.fetchUserInfo()
                }
        }
    }
    
    func fetchUserInfo() {
        guard let uid = self.userSession?.uid else { return }
        fetchService.fetchUserData(withuid: uid) { users in
            self.currentUserData = users
        }
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                withAnimation {
                    self.errorResetBool = true
                    self.errorResetString = error.localizedDescription
                    print(error.localizedDescription)
                }
                return
            } else {
                withAnimation {
                    self.errorResetBool = false
                    self.NOerrorResetBool = true
                }
            }
        }
    }
    
    func updateStatus(status: Bool){
        if currentUserData?.showProfilePic == false {
            Firestore.firestore().collection("registeredUserData")
                .document(currentUserData?.id ?? "")
                .updateData([
                    "showProfilePic": true
                ]){ error in
                    if error != nil{
                        print(error!)
                    }
                }
        }
        if currentUserData?.showProfilePic == true {
            Firestore.firestore().collection("registeredUserData").document(currentUserData?.id ?? "").updateData([
                "showProfilePic": false
            ]){ error in
                if error != nil{
                    print(error!)
                }
            }
        }
    }
    
    func updateStatusName(status: Bool){
        if currentUserData?.anonymousName == false {
            Firestore.firestore().collection("registeredUserData").document(currentUserData?.id ?? "").updateData([
                "anonymousName": true
            ]){ error in
                if error != nil{
                    print(error!)
                }
            }
        }
        if currentUserData?.anonymousName == true {
            Firestore.firestore().collection("registeredUserData").document(currentUserData?.id ?? "").updateData([
                "anonymousName": false
            ]){ error in
                if error != nil{
                    print(error!)
                }
            }
        }
    }
    
    func updateStatusUserName(status: Bool){
        if currentUserData?.anonymousUserName == false {
            Firestore.firestore().collection("registeredUserData").document(currentUserData?.id ?? "").updateData([
                "anonymousUserName": true
            ]){ error in
                if error != nil{
                    print(error!)
                }
            }
        }
        if currentUserData?.anonymousUserName == true {
            Firestore.firestore().collection("registeredUserData").document(currentUserData?.id ?? "").updateData([
                "anonymousUserName": false
            ]){ error in
                if error != nil{
                    print(error!)
                }
            }
        }
    }
}

