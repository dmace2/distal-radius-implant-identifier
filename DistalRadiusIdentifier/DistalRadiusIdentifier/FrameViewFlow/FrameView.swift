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
    @State var switchViews = false
    
    var body: some View {
        if let image = image {
            VStack {
                GeometryReader { geometry in
                    Image(image, scale: 1.0, orientation: .up, label: label)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.width,
                            alignment: .center)
                        .clipped()
                }
                Spacer()
                ArrowButton(buttonFunc: {
                    model.cameraManager.session.stopRunning()
                    self.capturedImage = model.frame
                    switchViews.toggle()
                }, labelText: "Take Photo", arrow: false)
                    .padding()
                
                NavigationLink(destination:
                                CapturedImageView(image: self.capturedImage)
                                .navigationTitle("Captured Image")
                               , isActive: $switchViews) {
                    EmptyView()
                }
            }
            .onAppear {
                model.cameraManager.session.startRunning()
            }
            
        } else {
            EmptyView()
        }
    }
}

//struct CameraView_Previews: PreviewProvider {
//  static var previews: some View {
//    FrameView(image: nil)
//  }
//}
