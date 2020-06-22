//
//  VideoMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
//import FIRStorage

struct VideoMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
        
    @Binding var showCalendarView: Bool
    @Binding var showButtonBar: Bool
    
    @State var showUploadingView: Bool = false
    func startUpload(url: URL) {
        // Where we'll store the video:
//        let storageReference = FIRStorage.storage().reference().child("video.mov")
//
//        // Start the video storage process
//        storageReference.putFile(videoURL as URL, metadata: nil, completion: { (metadata, error) in
//            if error == nil {
//                print("Successful video upload")
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
    }
    
    @State var pickedVideo: URL? = nil
    @State var isRecording: Bool = false

    
    var body: some View {
        VStack {
            if showUploadingView {
                Text("uploading...")
            } else {
                if pickedVideo == nil {
                    TakeVideoView(pickedVideo: self.$pickedVideo, isRecording: self.$isRecording, showButtonBar: self.$showButtonBar)
                } else {
                    VideoMemoryUploadView(pickedVideo: self.$pickedVideo, showButtonBar: self.$showButtonBar, startUpload: self.startUpload)
                }
            }
        }
    }
}

struct TakeVideoView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme

    @Binding var pickedVideo: URL?
    @Binding var isRecording: Bool
    @Binding var showButtonBar: Bool

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
            VideoCameraView(isWaitingForVideo: self.$showButtonBar , pickedVideo: self.$pickedVideo).getAndSetRecordingFunc(self.startRecording, self.stopRecording)
            Text("").makeColorCircle(colorScheme, Color.purple).padding(.vertical, 10).gesture(recordGesture).opacity(isRecording ? 0.5 : 1)
        }
    }
}

struct VideoMemoryUploadView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var pickedVideo: URL?
    @Binding var showButtonBar: Bool
    @Binding var showUploadingView: Bool
    
    var startUpload: (URL) -> ()

    var body: some View {
        VStack {
            if pickedVideo != nil {
                VideoPlayerContainerView(url: pickedVideo!)
            }
            HStack {
                Spacer()
                Button(action: {
                    self.pickedVideo = nil
                    self.showButtonBar = true
                }) {
                    Text("Cancel").customSubtitle(self.colorScheme)
                }
                Spacer(minLength: 15)
                Button(action: {
                    if let url = pickedVideo {
                        startUpload
                    }
                }) {
                    Text("Upload").customTitle()
                }
                Spacer()
            }
        }
    }
}
