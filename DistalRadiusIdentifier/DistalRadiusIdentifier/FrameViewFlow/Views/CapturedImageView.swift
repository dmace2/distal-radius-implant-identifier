//
//  CapturedImageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct CapturedImageView: View {
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @State var classificationModel = ClassificationModel()
    
    @State var switchViews = false
    var alignmentGuideWidth: CGFloat
    
    init() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            self.alignmentGuideWidth = UIScreen.main.bounds.width
            break
        case .pad:
            // It's an iPad (or macOS Catalyst)
            self.alignmentGuideWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.6
            break
        @unknown default:
            self.alignmentGuideWidth = UIScreen.main.bounds.width
            break
        }
        
    }
    
    var body: some View {
        GeometryReader { geo in
            if let capture = cameraModel.capturedImage{
                VStack {
                    ZStack {
                        FrameView(image: capture)
                            .environmentObject(cameraModel)
                            .navigationBarTitleDisplayMode(.inline)
                        
                    }
                    .frame(width: cameraModel.imageDimension, height: cameraModel.imageDimension)
                    
                    
                    Spacer()
                    
                    AlignmentGuideView(title1: "Does the image fit within the box?", title2: "Is the implant horizontally centered?")
                        .frame(width: self.alignmentGuideWidth)
                    
                    RoundedButton(color: Color("TechGold"), labelText: "Submit Photo for Classification", buttonFunc: {
                        classificationModel.userImage = cameraModel.capturedImage
                        switchViews.toggle()
                    })
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        InfoButtonView()
                    }
                }
                
                
                NavigationLink(destination:
                                ResultsView()
                                .environmentObject(classificationModel)
                                .navigationTitle("Results")
                                .navigationBarBackButtonHidden(true)
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
