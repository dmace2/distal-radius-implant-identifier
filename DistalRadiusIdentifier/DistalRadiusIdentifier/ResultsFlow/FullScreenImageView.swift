//
//  FullScreenImage.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct FullScreenImageView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: Image
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            image.resizable().aspectRatio(1, contentMode: .fit)
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct FullScreenImage_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenImage()
//    }
//}
