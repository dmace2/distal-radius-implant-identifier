//
//  ArrowButton.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/26/21.
//

import SwiftUI

struct ArrowButton: View {
    var buttonFunc: () -> Void
    var labelText: String
    var arrow = true
    
    
    var body: some View {
        if ProcessInfo.processInfo.isMacCatalystApp {
            Button(labelText, action: buttonFunc).padding()
        } else {
            Button(action: buttonFunc, label: {
                ZStack {
                    HStack {
                        Spacer()
                        Text(labelText)
                        Spacer()
                    }
                    if arrow {
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                    }
                }
                .padding()
            })
            .foregroundColor(Color(UIColor.systemBackground))
            .background(Color("TechBlue"))
            .cornerRadius(20)
            
        }
    }
}

struct ArrowButton_Previews: PreviewProvider {
    static var previews: some View {
        ArrowButton(buttonFunc: {}, labelText: "Foo")
    }
}
