//  AuthenticationViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    private let service = AuthenticationService()
    private let userDataService = UserDataService()
    private let storageService = FireStoreStorageService()
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    // TextFields String
    @Published var fullName: String = ""
    @Published var userName: String = ""
    @Published var emailId: String = ""
    @Published var password: String = ""
    
    // User Session
    @Published var userSession: FirebaseAuth.User?
    // Temporary User Session
    @Published var tempSessionForProfilePicSetup: FirebaseAuth.User?
    @Published var userDetails: UserProfileModel? = nil
    
    @Published var showProgressView: Bool = false
    @Published var emailSentSuccessfully: Bool = false
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    @Published var userCompletedSignUp: Bool = false
    
    // For Reloading Posts In Home Tab After Publishing Post..
    @Published var createPostSheetDismissied: Bool = false
    
    // For Reloading Posts After Deleting The Post
    @Published var deletedCompleted: Bool = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await self.fetchUserDetails()
        }
    }
    
    func createUser() async {
        do {
            withAnimation { showProgressView = true }
            
            // Validating Name And User Name
            guard ValidationService.validateName(fullName) else {
                throw ValidationError.invalidName
            }
            
            guard ValidationService.isValidUsername(userName) else {
                throw ValidationError.invalidUserName
            }
            
            // Checks username exists or not
            let userExists = try await userDataService.checkUserNameExists(userName: userName)
            
            guard !userExists else {
                throw ValidationError.userNameAlreadyExists
            }
            
            let tempSession = try await service.createUser(emailId: emailId, password: password)
            
            // Uploading data to firestore
            try await userDataService.setUserDataWithEmail(
                from: UserProfileModel(
                    withEmail: tempSession.user,
                    fullName: fullName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines),
                    userName: userName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                )
            )
            
            withAnimation {
                tempSessionForProfilePicSetup = tempSession.user
                userCompletedSignUp = true
            }
            // Haptic
            HapticManager.success()
            withAnimation { showProgressView = false }
        } catch {
            exceptionHandler(error: error)
            if error.localizedDescription == "The email address is already in use by another account." {
                errorDescription = "EmailID Already Exists"
            }
            if error.localizedDescription == "The password must be 6 characters long or more." {
                errorDescription = "Password Should Atleast Contains 6 characters."
            }
        }
    }
    
    func signInUser() async {
        do {
            withAnimation { showProgressView = true }
            let tempSession = try await service.signInUser(emailId: emailId, password: password)
            userSession = tempSession.user
            
            HapticManager.success()
            withAnimation { showProgressView = false }
        } catch {
            exceptionHandler(error: error)
            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                errorDescription = "Invalid User Or Password"
            }
        }
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            withAnimation {
                self.userSession = nil
            }
            isOnboardingViewActive.toggle()
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getResetPaswwordURL() async {
        do {
            withAnimation { showProgressView = true }
            
            try await service.resetPassword(email: emailId)
            
            withAnimation { showProgressView = false }
            withAnimation { emailSentSuccessfully = true }
            HapticManager.success()
        } catch {
            emailSentSuccessfully = false
            exceptionHandler(error: error)
        }
    }
    
    func setUserSessionAfterProfileSetup() {
        withAnimation {
            self.userSession = tempSessionForProfilePicSetup
        }
        Task {
            await self.fetchUserDetails()
        }
    }
    
    func continueWithGoogle() async {
        do {
            withAnimation { showProgressView = true }
            if let credential = try await service.signInWithGoogle() {
                let authDataResult = try await Auth.auth().signIn(with: credential)
                userSession = authDataResult.user
                
                // Setting data to firestore
                try await userDataService.setUserDataWithGoogle(
                    from: UserProfileModel(withGoogle: authDataResult.user)
                )
                
                await fetchUserDetails()
            }
            withAnimation { showProgressView = false }
            HapticManager.success()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func fetchUserDetails() async {
        if let tempUser = Auth.auth().currentUser {
            await userDataService.getUserData(for: tempUser.uid) { [weak self] userData in
                withAnimation {
                    self?.userDetails = userData
                }
            }
        }
        else {
            // TODO: Handle Exception
        }
    }
    
    func uploadImage(image: UIImage) async {
        do {
            withAnimation { showProgressView = true }
            let urlString = try await storageService.setImageToFirestore(image: image, path: .profilePhotos)
            print(urlString ?? "no url found")
            
            if let userUID = tempSessionForProfilePicSetup?.uid {
                print(userUID)
                try await userDataService.updateUserProfileURL(userUID: userUID, imageURL: urlString ?? "")
            } else {
                print("cant get user")
            }
            
            // Setting Up User Usesr Session
            setUserSessionAfterProfileSetup()
            
            HapticManager.success()
            
            withAnimation { showProgressView = false }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func follow(toUser: String) async {
        do {
            try await userDataService.follow(followTo: toUser)
            HapticManager.soft()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func unFollow(toUser: String) async {
        do {
            try await userDataService.unFollow(unFollowTo: toUser)
            HapticManager.soft()
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    // Examine (That Like PostUID Already Exists Or Not)
    func isAlreadyLiked(_ postUID: String) -> Bool {
        return userDetails?.userActivities.likedPostsId.contains(postUID) ?? false
    }
    
    // Examine (That Chatroom Already Joined Or Not)
    func isAlreadyJoined(_ chatRoom: String) -> Bool {
        return userDetails?.userActivities.joinedChatRooms.contains(chatRoom) ?? false
    }
    
    func isFriend(_ userUID: String?) -> Bool {
        return userDetails?.userActivities.followingsUID.contains(userUID ?? "nil") ?? false
    }
    
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        
        showProgressView = false
        HapticManager.error()
    }
}



