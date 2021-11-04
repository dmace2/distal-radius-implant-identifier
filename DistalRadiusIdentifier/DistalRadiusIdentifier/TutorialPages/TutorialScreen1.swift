//
//  OnboardingScreen1.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen1: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TutorialTitleAndSubheader(titleText: "Welcome to the GT/Emory Distal Radius Implant Identifier",
                                      subtitleText: "It’s the simplest way to identify distal radius implants, simply from an x-ray")
            
            Spacer()
            
            ArrowButton(buttonFunc: {
                withAnimation {
                    tabSelection = 2
                }
            }, labelText: "Get Started")
            
            Spacer().frame(height: 40)
            
        }
        .padding()
        
        
    }
}

//struct WelcomePage1_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage1(tabSelection: Binding<Int>(1))
//    }
//}
