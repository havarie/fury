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

let items: [BottomBarItem] = [
    BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
    BottomBarItem(icon: "heart", title: "Likes", color: .pink),
    BottomBarItem(icon: "magnifyingglass", title: "Search", color: .orange),
    BottomBarItem(icon: "person.fill", title: "Profile", color: .blue)
]

struct HomeView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showHome: Bool
    @State var showCalendarView: Bool = false
    @State var showCameraView: Bool = true
    
    @State var pickedImage: Image? = nil
    
    let user = Auth.auth().currentUser
    
    @State private var selectedIndex: Int = 1
    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: CalendarView(), isActive: self.$showCalendarView) {
                EmptyView()
            }
            VStack {
                //change the navbar color
                Rectangle()
                    .foregroundColor(selectedItem.color)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 0)
                    .navigationBarHidden(false)
                // selected photo
                pickedImage?.resizable().scaledToFit()
                if showCameraView {
                    CameraView(showCameraView: self.$showCameraView, pickedImage: self.$pickedImage)
                } else {
                    Text("nothing")
                }
                // todo: square frame
                Button(action: {
                    self.showCalendarView = true
                }) {
                    Text("New Memory").customSubtitle(colorScheme)
                }
                Button(action: {
                    
                }) {
                    Text("Take Photo").customCircleText(colorScheme)
                }
                BottomBar(selectedIndex: $selectedIndex, items: items)
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
