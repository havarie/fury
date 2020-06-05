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
    
    @State var alwaysShowCalendar = true
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
     
    var body: some View {
        ZStack {
            Color.backgroundColor(colorScheme)
            .edgesIgnoringSafeArea(.all)
            VStack {
                RKViewController(isPresented: self.$alwaysShowCalendar, rkManager: self.rkManager1)
            }
        }
        .navigationBarTitle("Send Message", displayMode: .inline)
    }
}
