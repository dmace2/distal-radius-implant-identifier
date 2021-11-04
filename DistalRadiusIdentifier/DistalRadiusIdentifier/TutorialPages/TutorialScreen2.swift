//
//  OnboardingScreen2.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen2: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TutorialTitleAndSubheader(titleText: "Take a Photo\nGet a Result", subtitleText: "Simply click the button below to classify a sample x-ray")
            
            Spacer()
            
            ArrowButton(buttonFunc: {
                withAnimation {
                    tabSelection = 3
                }
            }, labelText: "Continue")
            
            Spacer().frame(height: 40)
            
            
        }
        .padding()
        
    }
        
}
//
//struct WelcomePage2_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage2()
//    }
//}
