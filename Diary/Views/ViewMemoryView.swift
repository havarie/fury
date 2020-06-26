//
//  ViewMemoryView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/24/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ViewMemoryView: View {
    @Binding var videoPath: String
    @State var pickedUrl: URL? = nil
    func downloadAndShow() {
        if let uid = Auth.auth().currentUser?.uid {
            let storageReference = Storage.storage().reference().child(uid).child(videoPath)
            var fileUrl: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            fileUrl.appendPathComponent(videoPath)
            let downloadTask = storageReference.write(toFile: fileUrl) { url, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("error")
                } else {
                    self.pickedUrl = fileUrl
                }
            }
        }
    }
    var body: some View {
        Group {
            if pickedUrl != nil {
                VideoPlayerContainerView(url: pickedUrl!)
            } else {
                Text("Downloading memory...")
            }
        }.onAppear {
            self.downloadAndShow()
        }
    }
}

