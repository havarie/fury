//
//  ActivityIndicatorView.swift
//  appmaker
//
//  Created by Joseph Hinkle on 12/16/19.
//  Copyright © 2019 Joseph Hinkle. All rights reserved.
//
//  Source: https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
