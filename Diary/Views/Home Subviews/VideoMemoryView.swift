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
    
    var showCameraView: Bool {
        return pickedVideo == nil
    }
    @State var pickedVideo: URL? = nil
    @State var isRecording: Bool = false
    @ObservedObject var startRecording: ObservableContainer = ObservableContainer {}
    @ObservedObject var stopRecording: ObservableContainer = ObservableContainer {}

    
    var body: some View {
        let recordGesture = DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
            .onChanged { _ in
                if !self.isRecording {
                    self.startRecording.value()
                    withAnimation {
                        self.isRecording = true
                    }
                }
            }
            .onEnded { _ in
                if self.isRecording {
                    self.stopRecording.value()
                    withAnimation {
                        self.isRecording = false
                    }
                }
            }
        return VStack {
            if pickedVideo != nil {
                VideoPlayerContainerView(url: pickedVideo!)
            }
            if showCameraView {
                VideoCameraView(pickedVideo: self.$pickedVideo).getAndSetRecordingFunc(self.startRecording, self.stopRecording)
                Text("").makeColorCircle(colorScheme, Color.purple).padding(.vertical, 10).gesture(recordGesture).opacity(isRecording ? 0.5 : 1)
            } else {
                Text("Loading...")
            }
        }
    }
}
