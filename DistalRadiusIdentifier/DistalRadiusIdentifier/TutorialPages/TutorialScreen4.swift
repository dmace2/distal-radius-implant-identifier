//
//  OnboardingScreen4.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen4: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            Text("90.01%")
                .multilineTextAlignment(.center)
                .font(.system(size: 70).weight(.bold))
                .foregroundColor(Color("TechBlue"))
            
            Text("Synthes")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .font(.system(size: 40))
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            List(1..<15){ row in
                HStack {
                    if row == 1 {
                        Text("Synthes")
                        Spacer()
                        Text("90.41%").fontWeight(.bold)
                    } else if row == 2 {
                        Text("Acumed")
                        Spacer()
                        Text("8.59%").fontWeight(.bold)
                    } else {
                        Text("Company")
                        Spacer()
                        Text("< 1.00%").fontWeight(.bold)
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
             
            ArrowButton(buttonFunc: {
                withAnimation {
                    tabSelection = 5
                }
            }, labelText: "Continue")
            

            Spacer().frame(height: 40)
            
        }
        .padding()
    }
}

//struct WelcomeScreen4_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeScreen4()
//    }
//}
