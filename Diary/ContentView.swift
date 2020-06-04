//
//  ContentView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor(colorScheme)
                Text("Hello, World!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
