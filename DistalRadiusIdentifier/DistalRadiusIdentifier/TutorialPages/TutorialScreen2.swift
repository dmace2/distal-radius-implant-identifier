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
        GeometryReader { geo in
            VStack { // vertical stack
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width / 3)
                
                TutorialTitleAndSubheader(titleText: "Take a Photo\nGet a Result", subtitleText: "Simply click the button below to classify a sample x-ray")
                
                Spacer()
                
                ArrowButton(buttonFunc: {
                    withAnimation {
                        tabSelection = 3
                    }
                }, labelText: "Continue")
                
                Spacer().frame(height: 40)
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
            
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
