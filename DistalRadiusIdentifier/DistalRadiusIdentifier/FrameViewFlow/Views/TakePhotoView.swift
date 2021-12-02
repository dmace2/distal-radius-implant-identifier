//
//  TakePhotoView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct TakePhotoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    
    @State var switchViews = false
    @State var showErrorAlert: Bool = false
    
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
            VStack {
                ZStack {
                    FrameView(image: cameraModel.frame)
//                        .environmentObject(cameraModel)
                        .navigationBarTitleDisplayMode(.inline)
                    
                }
                .frame(width: cameraModel.imageDimension, height: cameraModel.imageDimension)
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text(cameraModel.error!.localizedDescription),
                          message: Text("Please allow camera access in Settings for implant identification"),
                          primaryButton: .default(Text("Open Settings"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }),
                          secondaryButton: .cancel(Text("Cancel"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }))
                }
                
                
                
                AlignmentGuideView(title1: "Get Close", subtitle1: "Fit plate tightly within bounds", title2: "Line Up", subtitle2: "Center plate vertically on red line")
                    .frame(width: self.alignmentGuideWidth)
                Spacer()
                
                NavigationLink(destination:
                                VerifyImageView()
                                .navigationTitle("Verify Image")
                               , isActive: $switchViews) {
                    EmptyView()
                }
                
                RoundedButton(color: Color("TechGold"), labelText: "Take Photo", buttonFunc: {
                    cameraModel.cameraManager.session.stopRunning()
                    cameraModel.capturedImage = cameraModel.frame?.cropping(to: CGRect(x: 0, y: cameraModel.frame!.height / 2 - cameraModel.frame!.width / 2, width: cameraModel.frame!.width, height: cameraModel.frame!.width))
                    switchViews.toggle()
                })
                    .padding()
                
                
            }
        }
        .onAppear {
            self.showErrorAlert = cameraModel.error != nil
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                InfoButtonView()
            }
        }
    }
}
