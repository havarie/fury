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
    
    @Binding var showHome: Bool
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            Color.backgroundColor(colorScheme)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Account").font(.headline).underline()
                VStack(alignment: .center) {
                    Text("Logged in as:")
                    Text("\(self.user?.email ?? "unknown")")
                }
                Button(action: {
                    do {
                        try FUIAuth.defaultAuthUI()?.signOut()
                    } catch {

                    }
                    self.showHome = false
                }, label: {
                    Text("Logout")
                })
            }
        }
        .navigationBarTitle("Home")
        .navigationBarBackButtonHidden(true)
    }
}
