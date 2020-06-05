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
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(120*60*60*24*365), mode: 0) // goes out to 120 years
     
    var body: some View {
//        ZStack {
//            Color.backgroundColor(colorScheme)
//            .edgesIgnoringSafeArea(.all)
            VStack {
                // need to RKViewController in VStack to allow it to frame properly
                VStack { RKViewController(isPresented: self.$alwaysShowCalendar, rkManager: self.rkManager1) }
                    .frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
                QuickPickView()
                    .frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
            }
//        }
        .navigationBarTitle("Send Message", displayMode: .inline)
    }
}

struct QuickPickView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Spacer()
            Text("QUICK PICK").customTitle()
            Button(action: {
                
            }) {
                Text("IN 1 DAY").customSubtitle(colorScheme)
            }
            Button(action: {
                
            }) {
                Text("IN 1 WEEK").customSubtitle(colorScheme)
            }
            Button(action: {
                
            }) {
                Text("IN 1 YEAR").customSubtitle(colorScheme)
            }
            Spacer()
            Button(action: {
                
            }) {
                Text("SEND").customCircleText(colorScheme)
            }
            Spacer()
        }
    }
}
