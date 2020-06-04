//
//  Color.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

extension Color {
    static func backgroundColor( _ colorScheme: ColorScheme ) -> Color {
        colorScheme == .light ?
            Color(red: 76.9/100.0, green: 95.3/100.0, blue: 100.0/100.0) :
            Color(red: 0/100.0, green: 17.4/100.0, blue: 21.7/100.0)
    }
    static func blackOrWhite( _ colorScheme: ColorScheme ) -> Color {
        colorScheme == .light ? .black : .white
    }
}
