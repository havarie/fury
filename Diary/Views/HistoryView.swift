//
//  HistoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/24/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

let memoriesRef = db.collection("memories")

struct HistoryView: View {
    
    let user = Auth.auth().currentUser!
    
    var body: some View {
        VStack {
            Text("History").customTitle()
                .padding(.bottom, 10)
            
        }.onAppear {
            let query = memoriesRef
                .whereField("owner", isEqualTo: self.user.uid)
                .whereField("notificationUTC", isLessThan: 1000000)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
