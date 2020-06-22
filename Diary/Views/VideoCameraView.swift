//
//  VideoCameraView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/9/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import MobileCoreServices

var activeCameraViewController: UIImagePickerController? = nil
struct VideoCameraView: UIViewControllerRepresentable {
    @Binding var pickedVideo: URL?
    
    func startRecording() {
        activeCameraViewController!.startVideoCapture()
    }
    func stopRecording() {
        activeCameraViewController!.stopVideoCapture()
    }
    
    func getAndSetRecordingFunc(_ startFunc: ObservableContainer<()->()>, _ stopFunc: ObservableContainer<()->()>) -> VideoCameraView {
        startFunc.value = startRecording
        stopFunc.value = stopRecording
        return self
    }
    
    func makeCoordinator() -> VideoCameraView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoCameraView>) -> UIViewController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = context.coordinator
        cameraViewController.sourceType = .camera
        cameraViewController.allowsEditing = false
        cameraViewController.cameraFlashMode = .auto
        cameraViewController.showsCameraControls = false
        cameraViewController.mediaTypes = [kUTTypeMovie as String]
        cameraViewController.cameraDevice = .front
        cameraViewController.cameraCaptureMode = .video
        activeCameraViewController = cameraViewController
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VideoCameraView>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: VideoCameraView
        
        init(_ cameraView: VideoCameraView) {
            self.parent = cameraView
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                self.parent.pickedVideo = videoURL
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {}
    }
}


final class ObservableContainer<T>: ObservableObject {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
