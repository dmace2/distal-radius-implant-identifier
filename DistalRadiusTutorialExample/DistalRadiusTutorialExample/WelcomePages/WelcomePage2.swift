//
//  WelcomePage2.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

struct WelcomePage2: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            Text("Take a Photo\nGet a Result")
                .multilineTextAlignment(.center)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(Color("TechBlue"))
            Text("Simply click the button below to classify a sample x-ray")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("SecondaryGray"))
                .font(.body)
                .padding(.leading, 20)
                .padding(.trailing, 20)
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
