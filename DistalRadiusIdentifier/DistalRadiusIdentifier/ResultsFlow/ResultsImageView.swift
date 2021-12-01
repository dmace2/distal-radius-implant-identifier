//
//  ResultsImageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsImageView: View {
    var image: Image
    var caption: String
    
    
    var body: some View {
        VStack(alignment:.center) {
            Text(caption).font(.footnote)
            image.resizable()//.frame(maxWidth: geo.size.width, maxHeight: geo.size.width, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct ResultsImageView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsImageView(image: Image("SampleXRay"), caption: "Test")
    }
}
