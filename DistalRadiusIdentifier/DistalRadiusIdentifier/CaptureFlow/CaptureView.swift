//
//  CaptureView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 1/6/22.
//

import SwiftUI
import CoreData

struct CaptureView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var image: UIImage? = UIImage(named: "Logo")
    @State var presentPicker = false
    @State var showingError = false
    
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @EnvironmentObject var classificationModel: ClassificationModel
    
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
            VStack {
                ZStack(alignment: .center) {
                    if let image = image {
                        Image(uiImage: image).resizable().scaledToFill()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.width,
                            alignment: .top)
                        .clipped()
                    } else {
                        Color.black.frame(
                            width: geo.size.width,
                            height: geo.size.width,
                            alignment: .center)
                            .onTapGesture {
                                self.presentPicker.toggle()
                            }
                    }
                    Rectangle()
                        .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.35))
                        .frame(width: geo.size.width / 50, height: geo.size.width, alignment: .top)
                        .allowsHitTesting(false)
                    Image("ViewFinder")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .scaledToFill()
                        .frame(
                            width: geo.size.width,
                            height: geo.size.width,
                            alignment: .center)
                        .clipped()
                        .allowsHitTesting(false)
                    
                    if let error = cameraModel.error {
                        ErrorView(error: "Unable to Access Cameras")
                                        .unredacted()
                                        .alert(isPresented: $showingError, content: {
                            Alert(
                                title: Text("Error: \(error.localizedDescription)"),
                                message: Text("Please enable camera access in settings in order to classify implants"),
                                primaryButton: .cancel(Text("Cancel"), action: {
                                    presentationMode.wrappedValue.dismiss()
                                }),
                                secondaryButton: .default(Text("Open Settings"), action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                    presentationMode.wrappedValue.dismiss()
                                })
                                
                            )
                        })
                    }
                    
                }
                .fullScreenCover(isPresented: $presentPicker) {
                    ZStack {
                        Color.black.ignoresSafeArea()
                        SystemImagePicker(image: $image)
                    }
                }
                
                Button("Retake Photo") { presentPicker.toggle() }
                .padding()
                
                Spacer()
                
                AlignmentGuideView(title1: "Does the image fit within the box?", title2: "Is the implant horizontally centered?")
                    .frame(width: geo.size.width)
                
                RoundedButton(color: .accentColor, labelText: "Submit Photo for Classification", buttonFunc: {
                    cameraModel.capturedImage = image
                    classificationModel.error = nil
                    classificationModel.isLoading.toggle()
                    switchViews.toggle()
                })
                    .padding()
                    .disabled(image == nil)
            }
            .onAppear {
                cameraModel.error = nil
                Task {
                    cameraModel.determineCameraPermissionStatus()
                    print(cameraModel.error)
                    if cameraModel.error == nil {
                        self.presentPicker.toggle()
                    } else {
                        self.showingError = true
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    InfoButtonView()
                }
            }
            
            
            NavigationLink(destination:
                            ResultsView()
                            .navigationBarBackButtonHidden(true)
                           , isActive: $switchViews) {
                EmptyView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct CaptureView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureView()
    }
}
