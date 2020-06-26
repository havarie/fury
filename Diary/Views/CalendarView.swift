//
//  CalendarView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseInstanceID


struct CalendarView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showCalendarView: Bool
    
    @Binding var videoPath: String
    
    @State var isLoading = false
    
    @State var alwaysShowCalendar = true
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(120*60*60*24*365), mode: 0) // goes out to 120 years
    
    func createVideoMemory() {
        if let date = rkManager1.selectedDate {
            if let userUid = Auth.auth().currentUser?.uid {
                self.isLoading = true
                let memoriesRef = db.collection("memories")
                var ref: DocumentReference? = nil
                ref = memoriesRef.addDocument(data: [
                    "owner": userUid,
                    "notificationSent": false,
                    "notificationTimestamp": Timestamp(date: date),
                    "type": "video",
                    "videoName": self.videoPath
                ]) { err in
                    if let err = err {
                        self.isLoading = false
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        self.isLoading = false
                        self.showCalendarView = false
                    }
                }
            }
        }
    }
     
    var body: some View {
        VStack {
            if self.isLoading {
                Text("Creating memory...")
            } else {
                // need to RKViewController in VStack to allow it to frame properly
                VStack { RKViewController(isPresented: self.$alwaysShowCalendar, rkManager: self.rkManager1) }
                    .frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
                QuickPickView(createVideoMemory: self.createVideoMemory, rkManager1: self.rkManager1)
                    .frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
            }
        }
        .navigationBarTitle("Send Message", displayMode: .inline)
    }
}

struct QuickPickView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let createVideoMemory: () -> ()
    let rkManager1: RKManager
    
    var body: some View {
        VStack {
            Spacer()
            Text("QUICK PICK").customTitle()
            Button(action: {
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
                let dateTomorrow = Calendar.current.date(from: tomorrow)!
                self.rkManager1.selectedDate = dateTomorrow
                self.createVideoMemory()
            }) {
                Text("IN 1 DAY").customSubtitle(colorScheme)
            }
            Button(action: {
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let nextWeek = DateComponents(year: now.year, month: now.month, day: now.day! + 7)
                self.rkManager1.selectedDate = Calendar.current.date(from: nextWeek)!
                self.createVideoMemory()
            }) {
                Text("IN 1 WEEK").customSubtitle(colorScheme)
            }
            Button(action: {
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let nextYear = DateComponents(year: now.year! + 1, month: now.month, day: now.day)
                self.rkManager1.selectedDate = Calendar.current.date(from: nextYear)!
                self.createVideoMemory()
            }) {
                Text("IN 1 YEAR").customSubtitle(colorScheme)
            }
            Spacer()
            Button(action: {
                self.createVideoMemory()
            }) {
                Text("SEND").customCircleText(colorScheme)
            }
            Spacer()
        }
    }
}
