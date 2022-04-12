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
    
    @State var image: UIImage?
    @State var croppedImage: UIImage?
    @State var showingCropper = false
    
    
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
                    if let image = croppedImage { //already cropped image
                        Image(uiImage: image).resizable().scaledToFill()
                            .frame(width: cameraModel.imageDimension, height: cameraModel.imageDimension)
                        .clipped()
                    } else if let image = image { //already taken image
                        Image(uiImage: image).resizable().scaledToFill()
                            .frame(width: cameraModel.imageDimension, height: cameraModel.imageDimension)
                        .clipped()
                    } else { //no image taken yet
                        Image("ExampleXRay")
                            .resizable().scaledToFill()
                            .frame(width: cameraModel.imageDimension, height: cameraModel.imageDimension)
                            .clipped()
                        
                        Text("EXAMPLE")
                            .font(.system(size: cameraModel.imageDimension / 5))
                            .foregroundColor(.red).opacity(0.3)
                            .rotationEffect(Angle.init(degrees: 45))
                    }
                    Rectangle() //center line
                        .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.5))
                        .frame(width: geo.size.width / 50, height: cameraModel.imageDimension, alignment: .top)
                        .allowsHitTesting(false)
                    Image("ViewFinder") //bounds
                        .resizable()
                        .foregroundColor(.accentColor)
                        .scaledToFill()
                        .frame(
                            width: cameraModel.imageDimension,
                            height: cameraModel.imageDimension,
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
                if cameraModel.error == nil {
                    HStack {
                        Button {
                            presentPicker.toggle()
                        } label: {
                            if image == nil {
                                Text("Take Photo")
                            } else {
                                Text("Retake Photo")
                            }
                        }
                        .frame(width: geo.size.width / 4)
                        .padding(geo.size.height / 100)
                        .foregroundColor(Color(UIColor.systemBackground)) // set text as white/black based on background color
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        
                        if #available(iOS 15.0, *), image != nil {
                            NavigationLink(destination: ImageCropAndRotationView(image: (image ?? UIImage(named: "ExampleXRay")!), croppedImage: $croppedImage)
                                            .navigationBarBackButtonHidden(true)
                                           , label: {
                                Text("Edit Photo")
                                .frame(width: geo.size.width / 4)
                                .padding(geo.size.height / 100)
                                .foregroundColor(Color(UIColor.systemBackground)) // set text as white/black based on background color
                                .background(Color.accentColor)
                                .cornerRadius(10)
                            })
                        }
                    }
                    .fullScreenCover(isPresented: $presentPicker) { //display the picker when clicking button
                        ZStack {
                            Color.black.ignoresSafeArea()
                            SystemImagePicker(image: $image, croppedImage: $croppedImage)
                        }
                    }
                    .padding(.bottom, geo.size.height / 50)
                }
                    
                Spacer()
                
                AlignmentGuideView(title1: "Does the image fit within the box?", title2: "Is the implant horizontally centered?")
                    .frame(width: self.alignmentGuideWidth)
                
                RoundedButton(color: .accentColor, labelText: "Submit Photo for Classification", buttonFunc: {
                    if croppedImage != nil {
                        cameraModel.capturedImage = croppedImage
                    } else {
                        cameraModel.capturedImage = image
                    }
                    
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
                    if cameraModel.error != nil {
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
