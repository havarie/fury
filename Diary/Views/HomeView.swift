//
//  HomeView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import KeyboardAvoider

let items: [BottomBarItem] = [
    BottomBarItem(icon: "text.bubble", title: "TEXT", color: .blue),
    BottomBarItem(icon: "camera.fill", title: "FOTO", color: .red),
    BottomBarItem(icon: "video.fill", title: "VIDEO", color: .purple),
    BottomBarItem(icon: "person.fill", title: "PROFILE", color: .orange)
]

struct HomeView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showHome: Bool
    @State var showCalendarView: Bool = false
    
    @State private var selectedIndex: Int = 1
    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }
    
    var title: String {
        items[selectedIndex].title
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
                Spacer()
                if selectedIndex == 0 {
                    TextMemoryView(showCalendarView: self.$showCalendarView)
                }
                if selectedIndex == 1 {
                    CameraMemoryView(showCalendarView: self.$showCalendarView)
                }
                if selectedIndex == 2 {
                    VideoMemoryView(showCalendarView: self.$showCalendarView)
                }
                if selectedIndex == 3 {
                    ProfileView(showHome: self.$showHome)
                }
                Spacer()
                BottomBar(selectedIndex: $selectedIndex, items: items)
            }.avoidKeyboard()
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // undo the animations being off because of auto-login
            UINavigationBar.setAnimationsEnabled(true)
        }
    }
}
