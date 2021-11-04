//
//  TutorialScreen5.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen5: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TutorialTitleAndSubheader(titleText: "Ready to \nGet Started?")
            
            
            Spacer()
            
            ArrowButton(buttonFunc: {}, labelText: "Finish Tutorial", arrow: false)
            
            Spacer().frame(height: 40)
            
        }
        .padding()
    }
}
//
//struct WelcomeScreen5_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeScreen5()
//    }
//}
