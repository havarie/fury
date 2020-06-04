//
//  UserService.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

enum UserType {
    case loggedInUser
    case uid(_ uid: String)
    
    func getUid() -> String {
        switch self {
        case .loggedInUser: return Auth.auth().currentUser?.uid ?? ""
        case .uid(let v): return v
        }
    }
}

class UserService: FirestoreHelper, ObservableObject {
    var collectionName = "users_public"
    
    var id = UUID()
    
    @Published var displayName: String = "DISPLAY_NAME"
    
    var uid: String {
        return userType.getUid()
    }
    var userType: UserType = .loggedInUser
    
    func refresh() {
        self.displayName = ""
        getDocument(uid) { result in
            DispatchQueue.main.async {
                self.displayName = result
            }
        }
    }
}


