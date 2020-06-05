//
//  TextMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import KeyboardAvoider

struct TextMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showCalendarView: Bool
    
    @State var memoryText: String = ""
    
    var body: some View {
        KeyboardAvoider {
            VStack {
                TextField("Write your memory here...", text: self.$memoryText)
            }
        }
    }
}
