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
    @State var isRecording: Bool = false
    @ObservedObject var startRecording: ObservableContainer = ObservableContainer {}

    
    var body: some View {
        let recordGesture = DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
            .onChanged { _ in
                if !self.isRecording {
                    print(">> touch down") // additional conditions might be here
                    self.startRecording.fun()
                }
                withAnimation {
                    self.isRecording = true
                }
            }
            .onEnded { _ in
                withAnimation {
                    self.isRecording = false
                }
                print("<< touch up")
            }
        return VStack {
            // selected photo
            pickedImage?.resizable().scaledToFit()
            if showCameraView {
                VideoCameraView(showCameraView: self.$showCameraView, pickedImage: self.$pickedImage).getAndSetRecordingFunc(self.startRecording)
            } else {
                Text("nothing")
            }
            // todo: square frame
            Text("").makeColorCircle(colorScheme, Color.purple).padding(.vertical, 10).gesture(recordGesture).opacity(isRecording ? 0.5 : 1)
        }
    }
}
