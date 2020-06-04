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
            Color(red: 12.3/20.0, green: 17.6/20.0, blue: 19.9/20.0) :
            Color(red: 7.3/155.0, green: 11.6/155.0, blue: 19.9/155.0)
    }
}
