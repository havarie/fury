//
//  BottomBarItemView.swift
//  BottomBar
//
//  Created by Bhavesh Chavda on 21/01/20.
//  Modified by Joseph Hinkle on 5/06/20.
//  Copyright © 2020 BhaveshChavda. All rights reserved.
//

import SwiftUI

public struct BottomBarItemView: View {
    @Binding public var selectedIndex: Int
    public let myIndex: Int
    public let item: BottomBarItem
    
    var isSelected: Bool {
        return myIndex == selectedIndex
    }
    
    public var body: some View {
        HStack {
            Image(systemName: item.icon)
                .imageScale(.large)
                .foregroundColor(isSelected ? item.color : .primary)
            
            if isSelected {
                Text(item.title)
                    .foregroundColor(item.color)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
        .background(
            Capsule()
                .fill(isSelected ? item.color.opacity(0.2) : Color.clear)
        )
    }
}
