//
//  VideoMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct VideoMemoryView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
        
    @Binding var showCalendarView: Bool
    @Binding var videoPath: String
    @Binding var showButtonBar: Bool
    
    @State var uploadMessage: String = ""
    @State var showUploadingView: Bool = false
    func startUpload(videoURL: URL) {
        showUploadingView = true
        // Where we'll store the video:
        if let uid = Auth.auth().currentUser?.uid {
            let videoName = "\(UUID().uuidString).mov"
            let storageReference = Storage.storage().reference().child(uid).child(videoName)
            videoPath = videoName

            // Start the video storage process
            let task = storageReference.putFile(from: videoURL)
            // Add a progress observer to an upload task
            task.observe(.progress) { snapshot in
                // A progress event occured
                switch snapshot.status {
                case .success:
                    self.showCalendarView = true
                case .failure:
                    self.uploadMessage = "Upload failed..."
                case .pause:
                    self.uploadMessage = "Upload paused..."
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        self.showButtonBar = true
                        self.showUploadingView = false
                        self.pickedVideo = nil
                    }
                case .resume: self.uploadMessage = "Upload resumed..."
                case .unknown:
                    self.uploadMessage = "Unknown event..."
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        self.showButtonBar = true
                        self.showUploadingView = false
                        self.pickedVideo = nil
                    }
                case .progress:
                    let percent = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 1)
                    if snapshot.progress?.completedUnitCount == snapshot.progress?.totalUnitCount {
                        self.showCalendarView = true
                        self.showButtonBar = true
                        self.showUploadingView = false
                        self.pickedVideo = nil
                    } else {
                        self.uploadMessage = "Uploading: \(percent)%"
                    }
                }
            }
        } else {
            self.uploadMessage = "Not logged in..."
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.showButtonBar = true
                self.showUploadingView = false
                self.pickedVideo = nil
            }
        }
    }
    
    @State var pickedVideo: URL? = nil
    @State var isRecording: Bool = false

    
    var body: some View {
        VStack {
            if showUploadingView {
                Text(self.uploadMessage)
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
                    if let url = self.pickedVideo {
                       self.startUpload(url)
                    }
                }) {
                    Text("Upload").customTitle()
                }
                Spacer()
            }
        }
    }
}
