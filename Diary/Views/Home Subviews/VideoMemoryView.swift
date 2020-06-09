//
//  VideoMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

struct VideoMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
        
        @Binding var showCalendarView: Bool
        
        @State var showCameraView: Bool = true
        @State var pickedImage: Image? = nil
        
        var body: some View {
            var isDown = false
            let recordGesture = DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                .onChanged { _ in
                    if !isDown {
                        print(">> touch down") // additional conditions might be here
                    }
                    isDown = true
                }
                .onEnded { _ in
                    isDown = false
                    print("<< touch up")
                }
            return VStack {
                // selected photo
                pickedImage?.resizable().scaledToFit()
                if showCameraView {
                    CameraView(showCameraView: self.$showCameraView, pickedImage: self.$pickedImage)
                } else {
                    Text("nothing")
                }
                // todo: square frame
                Text("").makeColorCircle(colorScheme, Color.purple).padding(.vertical, 10).gesture(recordGesture)
            }
        }
    }
