//
//  TutorialTitleAndSubheader.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

/**
 This is a reusable component for a title and subtitle pair that is used in the tutorial screens.
 */
struct TutorialTitleAndSubheader: View {
    var titleText: String // text for title
    var subtitleText: String? // text for subtitle (*Optional* string where default is nil)
    
    
    var body: some View {
        Text(titleText)
            .multilineTextAlignment(.center)
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.accentColor)
        
        if let subtitleText = subtitleText { // if subtitle text is not nil (aka passed in
            Text(subtitleText)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor.gray))
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
