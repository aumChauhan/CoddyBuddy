//  AuthenticationService.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

actor AuthenticationService {
    
    /// - Creates Accounts With Email (Using Firebase Auth Service).
    func createUser(emailId: String, password: String) async throws -> AuthDataResult {
        // POST REQUEST
        return try await Auth.auth()
            .createUser(withEmail: emailId, password: password)
    }
    
    /// - SignIn(With Email & Password) Validation Functions.
    func signInUser(emailId: String, password: String) async throws -> AuthDataResult {
        // POST REQUEST
        return try await Auth.auth()
            .signIn(withEmail: emailId, password: password)
    }
    
    /// - Send Reset Password Link To Provided Email
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    @MainActor
    /// - Continue With Google.
    func signInWithGoogle() async throws -> AuthCredential? {
        guard let topVC = SignINWithGoogleViewController.topViewController() else { throw URLError(.badURL) }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            return nil
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return credential
    }
}

