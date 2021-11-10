//
//  OnboardingScreen3.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen3: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        GeometryReader { geo in
            VStack { // vertical stack
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width / 3)
                
                TutorialTitleAndSubheader(titleText: "Ready to Submit?", subtitleText: "Once you’ve taken a photo, click the classification button to proceed")
                
                
                Spacer()
                
                Image("SampleXRay")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                
                //            Spacer(minLength: 200)
                Spacer()
                
                
                
                ArrowButton(buttonFunc: {
                    withAnimation {
                        tabSelection = 4
                    }
                }, labelText: "Continue")
                
                Spacer().frame(height: 40)
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
        }
        .padding()
    }
}

//struct WelcomePage3_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage3()
//    }
//}
