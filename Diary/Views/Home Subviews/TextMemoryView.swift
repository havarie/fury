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
    @State var memoryText: String = "okay"
    
    var body: some View {
        VStack {
            TextView(
                text: $memoryText,
                isEditing: $isEditing,
                placeholder: "Write your memory here..."
            )
        }
    }
}
