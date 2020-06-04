//
//  HomeView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseUI
import Resolver

struct HomeView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        VStack {
            Text("Account").font(.headline).underline()
            VStack(alignment: .center) {
                Text("Logged in as:")
                Text("\(self.user?.email ?? "unknown")")
            }
            Button(action: {
//                do {
//                    try FUIAuth.defaultAuthUI()?.signOut()
//                } catch {
//
//                }
//                let scene = UIApplication.shared.connectedScenes.first
//                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
//                    sd.loadLogin()
//                }
            }, label: {
                Text("Logout")
            })
        }
    }
}
