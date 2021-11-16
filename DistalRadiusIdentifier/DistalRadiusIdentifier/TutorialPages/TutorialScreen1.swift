//
//  OnboardingScreen1.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen1: View {
    @Binding var tabSelection: Int // Binding var means changes reflected in all places LIVE
    
    var body: some View {
        GeometryReader { geo in
            VStack { // vertical stack
                Image("Logo")
                    .resizable() // these are view modifiers, they edit the view they are attached to
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width / 3) // force width 250
                
                TutorialTitleAndSubheader(titleText: "Welcome to the GT/Emory Distal Radius Implant Identifier",
                                          subtitleText: "It’s the simplest way to identify distal radius implants, simply from an x-ray")
                
                Spacer()
                
                //- MARK: Here is where that function as a parameter is used in the button
                // Notice how the function is defined in the creation of the object? This is an *inline function*, or a *closure*
                ArrowButton(buttonFunc: {
                    withAnimation { // tells the view to that whatever changes to views that come from this are animated, not instant
                        tabSelection = 2 // increment variable in the container view
                    }
                }, labelText: "Get Started")
                
                Spacer().frame(height: 40)
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
        }
        
        .padding()
        
        
    }
}

//struct WelcomePage1_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage1(tabSelection: Binding<Int>(1))
//    }
//}
