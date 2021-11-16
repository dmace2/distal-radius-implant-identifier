//
//  TakePhotoView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct TakePhotoView: View {
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    
    
    var body: some View {
        ZStack {
            FrameView(image: cameraModel.frame)
                .environmentObject(cameraModel)
                
            
            ErrorView(error: cameraModel.error)
        }
    }
}

struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
