//
//  CalendarView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI


struct CalendarView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
//            NavigationLink(destination: HomeView(showHome: self.$showHome), isActive: self.$showHome) {
//                EmptyView()
//            }
            Color.backgroundColor(colorScheme)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("ok")
            }
        }
        .navigationBarTitle("Foto", displayMode: .inline)
    }
}
