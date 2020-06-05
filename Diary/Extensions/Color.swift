//
//  Color.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI
import Resolver

extension Color {
    static func backgroundColor( _ colorScheme: ColorScheme ) -> Color {
        whiteOrBlack(colorScheme)
//        colorScheme == .light ?
//            Color(red: 76.9/100.0, green: 95.3/100.0, blue: 100.0/100.0) :
//            Color(red: 0/100.0, green: 17.4/100.0, blue: 21.7/100.0)
    }
    static func blackOrWhite( _ colorScheme: ColorScheme ) -> Color {
        colorScheme == .light ? .black : .white
    }
    static func whiteOrBlack( _ colorScheme: ColorScheme, diff: Double = 0 ) -> Color {
        colorScheme == .light ? Color(white: 1 - diff/3) : Color(white: diff)
    }
}
