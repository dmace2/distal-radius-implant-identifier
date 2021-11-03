//
//  WelcomePage1.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

struct WelcomePage1: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            Text("Welcome to the GT/Emory Distal Radius Implant Identifier")
                .multilineTextAlignment(.center)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(Color("TechBlue"))
            Text("It’s the simplest way to identify distal radius implants, simply from an x-ray")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("SecondaryGray"))
                .font(.body)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
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
