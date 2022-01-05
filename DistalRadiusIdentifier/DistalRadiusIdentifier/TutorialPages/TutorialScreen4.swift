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
        GeometryReader { geo in
            VStack { // vertical stack
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width / 3)
                
                
                Text("Synthes")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 70).weight(.bold))
                    .foregroundColor(.accentColor)
                
                Text("90.01%")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.system(size: 40))
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                List(1..<15){ row in
                    HStack {
                        if row == 1 {
                            ResultsRowView(CompanyPercentage(company: "Synthes", percentage: 90.41), color: Color("AccentLight"))
                        } else if row == 2 {
                            ResultsRowView(CompanyPercentage(company: "Acumed", percentage: 8.59), color: Color("AccentLight"))
                        } else {
                            ResultsRowView(CompanyPercentage(company: "Company", percentage: 0.99), color: Color("AccentLight"))
                        }
                    }
                }
                .listStyle(.plain)
                
                Spacer(minLength: 15)
                
                ArrowButton(buttonFunc: {
                    withAnimation {
                        tabSelection = 5
                    }
                }, labelText: "Continue")
                
                
                Spacer().frame(height: 40)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
        }
        .padding()
    }
}

//struct WelcomeScreen4_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeScreen4()
//    }
//}
