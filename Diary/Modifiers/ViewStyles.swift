//
//  ViewStyles.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/5/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import SwiftUI

extension Text {
    func customTitle() -> Text {
        self.font(.largeTitle).fontWeight(.bold).foregroundColor(Color.red)
    }
    func customSubtitle(_ colorScheme: ColorScheme) -> Text {
        self.font(.title).fontWeight(.bold).foregroundColor(Color.blackOrWhite(colorScheme))
    }
    func customCircleText(_ colorScheme: ColorScheme) -> some View {
        self.font(.largeTitle).fontWeight(.bold).foregroundColor(Color.blackOrWhite(colorScheme))
            .frame(width: 120, height: 120)
            .background(Color.red)
            .clipShape(Circle())
    }
}
