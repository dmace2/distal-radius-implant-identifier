//
//  TakePhotoView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct TakePhotoView: View {
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @State var switchViews = false
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    FrameView(image: cameraModel.frame)
                        .environmentObject(cameraModel)
                        .navigationBarTitleDisplayMode(.inline)
                    
                    ErrorView(error: cameraModel.error)
                }
                .frame(height: geo.size.width)
            
            
                Spacer()
                
                AlignmentGuideView(title1: "Get Close", subtitle1: "Fit plate tightly within bounds", title2: "Line Up", subtitle2: "Center plate vertically on red line")
                
                NavigationLink(destination:
                                CapturedImageView().environmentObject(cameraModel)
                                .navigationTitle("Captured Image")
                               , isActive: $switchViews) {
                    EmptyView()
                }
                GoldButton(buttonFunc: {
                    cameraModel.cameraManager.session.stopRunning()
                    cameraModel.capturedImage = cameraModel.frame?.cropping(to: CGRect(x: 0, y: cameraModel.frame!.height / 2 - cameraModel.frame!.width / 2, width: cameraModel.frame!.width, height: cameraModel.frame!.width))
                    switchViews.toggle()
                }, labelText: "Take Photo")
                    .padding()
            }
        }
    }
}

struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView().environmentObject(CameraFrameViewModel())
    }
}
