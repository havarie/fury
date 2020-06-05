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
    func customText(_ colorScheme: ColorScheme) -> Text {
        self.font(.subheadline).fontWeight(.bold).foregroundColor(Color.blackOrWhite(colorScheme))
    }
    func customCircleText(_ colorScheme: ColorScheme) -> some View {
        self.font(.largeTitle).fontWeight(.bold).foregroundColor(Color.blackOrWhite(colorScheme))
            .frame(width: 120, height: 120)
            .background(Color.red)
            .clipShape(Circle())
    }
    func makeColorCircle(_ colorScheme: ColorScheme, _ color: Color) -> some View {
        self.frame(width: 65, height: 65)
        .background(Color.whiteOrBlack(colorScheme).opacity(0.5))
        .clipShape(Circle()).frame(width: 95, height: 95)
        .background(color.opacity(0.3))
        .clipShape(Circle())
    }
}
