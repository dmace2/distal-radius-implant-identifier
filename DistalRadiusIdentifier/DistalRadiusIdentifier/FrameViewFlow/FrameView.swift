//
//  FrameView.swift
//  DistalRadiusIdentifier
//
//  Created by Blake Sanie on 11/15/21.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct FrameView: View {
    var image: CGImage?
    
    private let label = Text("Video feed")
    @EnvironmentObject var model: CameraFrameViewModel
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.bottom)
            VStack {
                GeometryReader { geo in
                    if let image = image {
                        ZStack(alignment: .center) {
                            Image(image, scale: 1.0, label: label)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: model.imageDimension,
                                    height: model.imageDimension,
                                    alignment: .center)
                                .clipped()
                            Rectangle()
                                .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.35))
                                .frame(width: geo.size.width / 50, height: model.imageDimension, alignment: .top)
                            Image("ViewFinder")
                                .resizable()
                                .foregroundColor(.blue)
                                .scaledToFill()
                                .frame(
                                    width: model.imageDimension,
                                    height: model.imageDimension,
                                    alignment: .center)
                                .clipped()
                            
                        }
                    }
                }
            }
            
        }
        .onAppear {
            withAnimation {
                model.cameraManager.session.startRunning()
            }
        }
    }
}

//struct CameraView_Previews: PreviewProvider {
//  static var previews: some View {
//    FrameView(image: nil)
//  }
//}
