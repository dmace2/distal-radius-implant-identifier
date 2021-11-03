//
//  TutorialTitleAndSubheader.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialTitleAndSubheader: View {
    var titleText: String
    var subtitleText: String?
    
    
    var body: some View {
        Text(titleText)
            .multilineTextAlignment(.center)
            .font(.largeTitle.weight(.bold))
            .foregroundColor(Color("TechBlue"))
        
        if let subtitleText = subtitleText {
            Text(subtitleText)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .font(.body)
                .padding(.leading, 20)
                .padding(.trailing, 20)
        }
        
        
    }
}
//
//struct TutorialTitleAndSubheader_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialTitleAndSubheader()
//    }
//}
