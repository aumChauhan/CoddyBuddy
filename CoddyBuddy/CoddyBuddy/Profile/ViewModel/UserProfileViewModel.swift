//  UserProfileViewModel.swift
//  Created by Aum Chauhan on 09/08/23.

import SwiftUI
import Foundation
import FirebaseFirestore

enum ProfileRefernce {
    case followers
    case followings
    case viewer
    case members
}

@MainActor
class UserProfileViewModel: ObservableObject {
    
    private var userDataService = UserDataService()
    
    var followersLastSnapDoc: DocumentSnapshot? = nil
    var followingsLastSnapDoc: DocumentSnapshot? = nil
    
    @Published var userInfo: UserProfileModel? = nil
    @Published var followers: [UserProfileModel] = []
    @Published var followings: [UserProfileModel] = []
    
    func getUserInfo(forUID: String) async {
        await userDataService.getUserData(for: forUID) { [weak self] userData in
            self?.userInfo = userData
        }
    }
    
    func getFollowers(user: UserProfileModel, emptyData: Bool? = nil) async {
        do {
            let (users, lastDoc) = try await userDataService.fetchUsersInfo(.followers, user: user, lastDocument: followersLastSnapDoc)
            
            if emptyData ?? false {
                followers = []
                followersLastSnapDoc = nil
            }
            
            withAnimation {
                self.followers.append(contentsOf: users)
                self.followersLastSnapDoc = lastDoc
            }
        } catch { }
    }
    
    func getFollowings(user: UserProfileModel, emptyData: Bool? = nil) async {
        do {
            let (users, lastDoc) = try await userDataService.fetchUsersInfo(.followings, user: user, lastDocument: followingsLastSnapDoc)
            
            if emptyData ?? false {
                followings = []
                followingsLastSnapDoc = nil
            }
            
            withAnimation {
                self.followings.append(contentsOf: users)
                self.followingsLastSnapDoc = lastDoc
            }
        } catch { }
    }
}
