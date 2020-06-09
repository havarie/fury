//
//  VideoCameraView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/9/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

struct VideoCameraView: UIViewControllerRepresentable {
    
    @Binding var showCameraView: Bool
    @Binding var pickedImage: Image?
    @Binding var isRecording: Bool {
        didSet{
            print("didSet: oldValue=\(oldValue) newValue=\(isRecording)")
            //Write code, function do what ever you want todo
        }
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
        cameraViewController.cameraCaptureMode = .video
        
//        cameraViewController.startVideoCapture()
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
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            parent.pickedImage = Image(uiImage: uiImage)
            parent.showCameraView = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCameraView = false
        }
    }
}
