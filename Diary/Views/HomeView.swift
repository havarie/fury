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
    @State var showNewMemory: Bool = false
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            NavigationLink(destination: NewMemoryView(), isActive: self.$showNewMemory) {
                EmptyView()
            }
            Color.backgroundColor(colorScheme)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.showNewMemory = true
                }) {
                    Text("New Memory")
                }
            }
        }
        .navigationBarTitle("Foto", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            do {
                try FUIAuth.defaultAuthUI()?.signOut()
            } catch {

            }
            self.showHome = false
        }, label: {
            Text("Logout")
        }))
    }
}



// for showing login information
//Spacer()
//Text("Account").font(.headline).underline()
//VStack(alignment: .center) {
//    Text("Logged in as:")
//    Text("\(self.user?.email ?? "unknown")")
//}
