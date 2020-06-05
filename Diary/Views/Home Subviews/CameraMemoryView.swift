//
//  CameraMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

struct CameraMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var showCalendarView: Bool
    
    @State var showCameraView: Bool = true
    @State var pickedImage: Image? = nil
    
    var body: some View {
        VStack {
            // selected photo
            pickedImage?.resizable().scaledToFit()
            if showCameraView {
                CameraView(showCameraView: self.$showCameraView, pickedImage: self.$pickedImage)
            } else {
                Text("nothing")
            }
            // todo: square frame
            Button(action: {
                self.showCalendarView = true
            }) {
                Text("New Memory").customSubtitle(colorScheme)
            }
            Button(action: {
        
            }) {
                Text("Take Photo").customCircleText(colorScheme)
            }
        }
    }
}

