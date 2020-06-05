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
    @State var showCalendarView: Bool = false
    @State var showCameraView: Bool = true
    
    @State var pickedImage: Image? = nil
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            NavigationLink(destination: CalendarView(), isActive: self.$showCalendarView) {
                EmptyView()
            }
            VStack {
                pickedImage?.resizable().scaledToFit()
                if showCameraView {
                    CameraView(showCameraView: self.$showCameraView, pickedImage: self.$pickedImage)
                } else {
                    
                }
                Button(action: {
                    self.showCalendarView = true
                }) {
                    Text("New Memory").customSubtitle(colorScheme)
                }
                Button(action: {
                    
                }) {
                    Text("Take Photo").customCircleText(colorScheme)
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
