//
//  ArrowButton.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 10/26/21.
//

import SwiftUI

/**
 This is a reusable component for the button with the arrow.
 It uses rounded corner blue button on iOS/iPadOS devices, but the standard macOS buttons on Macs.
 */
struct ArrowButton: View {
    var buttonFunc: () -> Void // take in a function as a parameter, which is defined when you create component instance
    var labelText: String // text for button
    var arrow = true // whether to show the button
    
    
    var body: some View {
        if ProcessInfo.processInfo.isMacCatalystApp {
            // if the app is mac, do general macOS button
            Button(labelText, action: buttonFunc).padding()
        } else {
            Button(action: buttonFunc, label: {
                ZStack { // stack things on top of each other depth-wise
                    HStack { // width-wise stack
                        Spacer()
                        Text(labelText)
                        Spacer()
                    }
                    if arrow { //add the arrow to zstack if we want it
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                    }
                }
                .padding()
            })
            .foregroundColor(Color(UIColor.systemBackground)) // set text as white/black based on background color
            .background(Color("AccentLight")) // button is blue
            .cornerRadius(20) // round corners
            
        }
    }
}

struct ArrowButton_Previews: PreviewProvider {
    static var previews: some View {
        ArrowButton(buttonFunc: {}, labelText: "Foo")
    }
}
