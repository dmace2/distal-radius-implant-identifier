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
    var caption: String?
    @State var tapped = false
    
    
    init(caption: String?, url: URL?) {
        self.caption = caption
        self.url = url
    }
    
    init(caption: String?, image: Image?) {
        self.caption = caption
        self.image = image
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    
    
    var body: some View {
        VStack(alignment:.center) {
            if let caption = caption {
                Text(caption).font(.footnote)
                Spacer()
            }
            
            if let image = image {
                image.resizable()
                    .scaledToFit()
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
                        .scaledToFit()
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
                    }
                }
            }
            
        }
    }
}
