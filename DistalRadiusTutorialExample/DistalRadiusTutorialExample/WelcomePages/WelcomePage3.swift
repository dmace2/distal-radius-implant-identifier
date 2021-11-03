//
//  WelcomePage3.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

struct WelcomePage3: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            Text("Ready to Submit?")
                .multilineTextAlignment(.center)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(Color("TechBlue"))
            Text("Once you’ve taken a photo, click the classification button to proceed")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("SecondaryGray"))
                .font(.body)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
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
        .padding()
    }
}

//struct WelcomePage3_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomePage3()
//    }
//}
