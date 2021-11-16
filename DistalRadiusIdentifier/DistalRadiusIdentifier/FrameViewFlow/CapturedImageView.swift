//
//  CapturedImageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct CapturedImageView: View {
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @State var switchViews = false
    
    var body: some View {
        GeometryReader { geo in
            if let capture = cameraModel.capturedImage{
                VStack {
                    ZStack {
                        Image(capture, scale: 1.0, orientation: .up, label: Text("Captured Image"))
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.width,
                                alignment: .center)
                            .clipped()
                        
                        Rectangle()
                            .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.35))
                            .frame(width: geo.size.width / 50, height: geo.size.width, alignment: .top)
                        
                    }
                    .frame(height: geo.size.width)
                    
                    
                    Spacer()
                    
                    AlignmentGuideView(title1: "Does the image fit within the box?", title2: "Is the implant horizontally centered?")
                    
                    GoldButton(buttonFunc: {
                        switchViews.toggle()
                    }, labelText: "Submit Photo for Classification")
                        .padding()
                }
                
                
                NavigationLink(destination:
                                Text("Thank you Dr. Hibbard and Dr. HB!")
                                .navigationTitle("Results")
                               , isActive: $switchViews) {
                    EmptyView()
                }
            }
        }
    }
}

//struct CapturedImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapturedImageView(image: <#CGImage#>)
//    }
//}
