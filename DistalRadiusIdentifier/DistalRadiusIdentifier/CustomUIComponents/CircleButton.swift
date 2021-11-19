//
//  CircleButton.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/17/21.
//

import SwiftUI

struct CircleButton: View {
    var text: String
    var size: CGFloat
    var action: () -> Void
    
    init(_ text: String, size: CGFloat, action: @escaping () -> Void) {
        self.text = text
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
                        Image(systemName: text).resizable().padding(size / 5)
                        .frame(width: size, height: size)
                        .foregroundColor(Color("TechGold"))
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton("plus.magnifyingglass", size: 100, action: {})
    }
}
