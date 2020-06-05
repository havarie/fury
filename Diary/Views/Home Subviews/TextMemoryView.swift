//
//  TextMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import TextView


struct TextMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showCalendarView: Bool
    
    @State var isEditing = true
    @State var memoryText: String = ""
    
    var body: some View {
        VStack {
            TextView(
                text: $memoryText,
                isEditing: $isEditing,
                placeholder: "Write your memory here..."
            )
            Button(action: {
                self.showCalendarView = true
            }) {
                Text("").makeColorCircle(colorScheme, Color.blue)
            }.padding(.vertical, 10)
        }
    }
}
