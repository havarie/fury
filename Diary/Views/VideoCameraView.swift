//
//  VideoCameraView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/9/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct VideoCameraView: UIViewControllerRepresentable {
    @State var cameraViewController: UIImagePickerController? = nil
    @Binding var showCameraView: Bool
    @Binding var pickedImage: Image?
    
    func startRecording() {
        cameraViewController?.startVideoCapture()
    }
    func stopRecording() {
        cameraViewController?.stopVideoCapture()
        
        showCameraView = false
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
        let view = UIImagePickerController()
        view.delegate = context.coordinator
        view.sourceType = .camera
        view.allowsEditing = false
        view.cameraFlashMode = .auto
        view.showsCameraControls = false
        view.mediaTypes = [kUTTypeMovie as String]
        view.cameraDevice = .front
        view.cameraCaptureMode = .video
        cameraViewController = view
        return view
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


final class ObservableContainer<T>: ObservableObject {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
