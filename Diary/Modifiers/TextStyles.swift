//
//  TextStyles.swift
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
    func customSubtitle() -> Text {
        self.font(.subheadline).fontWeight(.bold).foregroundColor(Color.black)
    }
}
