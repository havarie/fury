//
//  ProfileView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseUI

struct ProfileView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showHome: Bool
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        // for showing login information
        VStack {
            Spacer()
            Text("Logged in as:").customTitle()
            Text("\(self.user?.email ?? "unknown")").customText(colorScheme)
            Spacer()
            Button(action: {
                do {
                    try FUIAuth.defaultAuthUI()?.signOut()
                } catch {

                }
                self.showHome = false
            }, label: {
                Text("Logout").customSubtitle(colorScheme)
            })
            Spacer()
        }
    }
}

