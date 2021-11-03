//
//  WelcomeScreen5.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

struct WelcomePage5: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            Text("Ready to \nGet Started?")
                .multilineTextAlignment(.center)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(Color("TechBlue"))
            
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
