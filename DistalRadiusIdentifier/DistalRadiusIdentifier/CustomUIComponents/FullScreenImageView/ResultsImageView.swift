//
//  ResultsImageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ExpandingImageView: View {
    var image: Image?
    var url: URL?
    var caption: String
    @State var tapped = false
    
    
    var body: some View {
        VStack(alignment:.center) {
            Text(caption).font(.footnote)
            if let image = image {
                image.resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        tapped.toggle()
                    }
                    .fullScreenCover(isPresented: $tapped) {
                        FullScreenImageView(image: image)
                    }
            }
            
            if let url = url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            tapped.toggle()
                        }
                        .fullScreenCover(isPresented: $tapped) {
                            FullScreenImageView(image: image)
                        }
                } placeholder: {
                    ZStack {
                        Color.clear.ignoresSafeArea()
                        ProgressView()
                                //.aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            
        }
    }
}

struct ResultsImageView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandingImageView(image: Image("SampleXRay"), caption: "Test")
    }
}
