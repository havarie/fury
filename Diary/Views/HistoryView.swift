//
//  HistoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/24/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct HistoryView: View {
    
    var body: some View {
        VStack {
            Text("History").customTitle()
                .padding(.bottom, 10)
            
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
