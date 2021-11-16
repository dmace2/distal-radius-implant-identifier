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
    @State var capturedImage: CGImage?
    
    private let label = Text("Video feed")
    @EnvironmentObject var model: CameraFrameViewModel
    
    var body: some View {
        ZStack {
            Color("TechBlue_SameDark").edgesIgnoringSafeArea(.bottom)
            VStack {
                GeometryReader { geo in
                    if let image = image {
                        ZStack {
                            Image(image, scale: 1.0, orientation: .up, label: label)
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
