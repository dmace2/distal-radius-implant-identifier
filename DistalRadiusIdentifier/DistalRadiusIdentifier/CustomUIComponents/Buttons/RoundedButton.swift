//
//  GoldButton.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

/**
 This is a reusable component for the button with the arrow.
 It uses rounded corner blue button on iOS/iPadOS devices, but the standard macOS buttons on Macs.
 */
struct RoundedButton: View {
    @State var color: Color = Color("AccentLight")
    var labelText: String // text for button
    var buttonFunc: () -> Void // take in a function as a parameter, which is defined when you create component instance
    
    
    
    var body: some View {
        if ProcessInfo.processInfo.isMacCatalystApp {
            // if the app is mac, do general macOS button
            Button(labelText, action: buttonFunc).padding()
        } else {
            Button(action: buttonFunc, label: {
                HStack { // width-wise stack
                    Spacer()
                    Text(labelText)
                    Spacer()
                }
                .padding()
            })
                .foregroundColor(Color(UIColor.systemBackground)) // set text as white/black based on background color
                .background(color) // button is the color passed in
                .cornerRadius(20) // round corners
            
        }
    }
}
