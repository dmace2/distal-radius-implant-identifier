//
//  CapturedImageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct CapturedImageView: View {
    var image: CGImage?
    
    var body: some View {
        if let image = image {
            VStack {
                GeometryReader { geometry in
                    Image(image, scale: 1.0, orientation: .up, label: Text("Captured Image"))
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.width,
                            alignment: .center)
                        .clipped()
                }
                
            }
            
        } else {
            EmptyView()
        }
    }
}

//struct CapturedImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapturedImageView(image: <#CGImage#>)
//    }
//}
