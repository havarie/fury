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
        ScrollView {
            Text("Logged in as:").customTitle()
                .padding(.bottom, 10)
            Text("\(self.user?.email ?? "unknown")").customText(colorScheme)
                .padding(.bottom, 10)
            Button(action: {
                do {
                    try FUIAuth.defaultAuthUI()?.signOut()
                } catch {

                }
                self.showHome = false
            }, label: {
                Text("Logout").customSubtitle(colorScheme)
            })
            Spacer(minLength: 10)
            HistoryView()
        }
    }
}

