//
//  FullScreenImage.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct FullScreenImageView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: Image?
    var url: URL?
    
    init(url: URL) {
        self.url = url
    }
    
    init(image: Image) {
        self.image = image
    }
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                if let image = image {
                    image.resizable().scaledToFit()
                        .pinchToZoom()
                }
                    
                if let url = url {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .pinchToZoom()
                }
                
            }
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
