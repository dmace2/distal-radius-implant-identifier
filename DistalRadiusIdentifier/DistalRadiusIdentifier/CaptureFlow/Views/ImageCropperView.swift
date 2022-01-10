//
//  ImageCroppingView.swift
//  codeTutorial_imageCropper
//
//  Created by Christopher Guirguis on 12/17/20.
//

import SwiftUI
import SlidingRuler

var UniversalSafeOffsets = UIApplication.shared.windows.first?.safeAreaInsets

@available(iOS 15.0, *)
struct ImageCropAndRotationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    
    //These are the initial dimension of the actual image
    @State var imageWidth:CGFloat = 0
    @State var imageHeight:CGFloat = 0
    
    @State var croppingOffset = CGSize(width: 0, height: 0)
    @State var croppingMagnification:CGFloat = 1
    
    var image:UIImage
    var previousCrop: UIImage?
    
    @Binding var croppedImage:UIImage?
    
    @State var rotationAngle: Double = 0
    
    private var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.generatesDecimalNumbers = false
        return f
    }
    
    
    
    init(image: UIImage, croppedImage: Binding<UIImage?>) {
        self.image = image
        
        self._croppedImage = croppedImage
        self.previousCrop = croppedImage.wrappedValue
        
    }
    
    var body: some View {
        ZStack{
            //Black background
            Color.black
                .navigationTitle("Edit Image")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitleTextColor(.white)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            croppedImage = previousCrop
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel").foregroundColor(.red)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let rotatedImage = image.rotated(by: Measurement(value: rotationAngle, unit: .degrees))!
                            let cgImage: CGImage = rotatedImage.cgImage!
                            let scaler = CGFloat(cgImage.width)/imageWidth
                            let dim:CGFloat = getDimension(w: CGFloat(cgImage.width), h: CGFloat(cgImage.height))

                            let xOffset = (((imageWidth/2) - (getDimension(w: imageWidth, h: imageHeight*0.999) * croppingMagnification/2)) + croppingOffset.width) * scaler
                            let yOffset = (((imageHeight/2) - (getDimension(w: imageWidth, h: imageHeight*0.999) * croppingMagnification/2)) + croppingOffset.height) * scaler
                            let scaledDim = dim * croppingMagnification


                            if let cImage = cgImage.cropping(to: CGRect(x: xOffset, y: yOffset, width: scaledDim, height: scaledDim)) {
                                croppedImage = UIImage(cgImage: cImage)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text("Done").foregroundColor(Color("Gold"))
                        }
                    }
                }
            VStack{
                Spacer()
                    .frame(height: UniversalSafeOffsets?.top ?? 0)
                Spacer()
                ZStack{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(rotationAngle))

                    
                        .overlay(GeometryReader{geo -> AnyView in
                            DispatchQueue.main.async{
                                self.imageWidth = geo.size.width * 0.999
                                self.imageHeight = geo.size.height * 0.999
                            }
                            return AnyView(EmptyView().foregroundColor(.clear))
                        })
                    
                    ViewFinderView(imageWidth: self.$imageWidth, imageHeight: self.$imageHeight, finalOffset: $croppingOffset, finalMagnification: $croppingMagnification)
                    
                    
                }
                .padding()
                Spacer()
                
                SlidingRuler(value: $rotationAngle, in: -30...30, step: 10, snap: .fraction, tick: .fraction, formatter: formatter)
                    .padding(.bottom)
            }
        }//.edgesIgnoringSafeArea(.vertical)
    }
}


struct ViewFinderView:View{
    
    @Binding var imageWidth:CGFloat
    @Binding var imageHeight:CGFloat
    @State var center:CGFloat = 0
    
    @State var activeOffset:CGSize = CGSize(width: 0, height: 0)
    @Binding var finalOffset:CGSize
    
    @State var activeMagnification:CGFloat = 1
    @Binding var finalMagnification:CGFloat
    
    @State var dotSize:CGFloat = 13
    var dotColor = Color.init(white: 1).opacity(0.9)
    var surroundingColor = Color.black.opacity(0)
    
    var body: some View {
        ZStack{
            //These are the views for the surrounding rectangles
            Group{
                Rectangle()
                //                .foregroundColor(Color.red.opacity(0.3))
                    .foregroundColor(surroundingColor)
                    .frame(width: ((imageWidth-getDimension(w: imageWidth, h: imageHeight*0.999))/2) + activeOffset.width + (getDimension(w: imageWidth, h: imageHeight*0.999) * (1 - activeMagnification) / 2), height: imageHeight)
                    .offset(x: getSurroundingViewOffsets(horizontal: true, left_or_up: true), y: 0)
                Rectangle()
                //                .foregroundColor(Color.blue.opacity(0.3))
                    .foregroundColor(surroundingColor)
                
                    .frame(width: ((imageWidth-getDimension(w: imageWidth, h: imageHeight*0.999))/2) - activeOffset.width + (getDimension(w: imageWidth, h: imageHeight*0.999) * (1 - activeMagnification) / 2), height: imageHeight)
                    .offset(x: getSurroundingViewOffsets(horizontal: true, left_or_up: false), y: 0)
                Rectangle()
                //                .foregroundColor(Color.yellow.opacity(0.3))
                    .foregroundColor(surroundingColor)
                    .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999) * activeMagnification, height: ((imageHeight-getDimension(w: imageWidth, h: imageHeight*0.999))/2) + activeOffset.height + (getDimension(w: imageWidth, h: imageHeight*0.999) * (1 - activeMagnification) / 2))
                    .offset(x: activeOffset.width, y: getSurroundingViewOffsets(horizontal: false, left_or_up: true))
                Rectangle()
                //                .foregroundColor(Color.green.opacity(0.3))
                    .foregroundColor(surroundingColor)
                    .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999) * activeMagnification, height: ((imageHeight-getDimension(w: imageWidth, h: imageHeight*0.999))/2) - activeOffset.height + (getDimension(w: imageWidth, h: imageHeight*0.999) * (1 - activeMagnification) / 2))
                    .offset(x: activeOffset.width, y: getSurroundingViewOffsets(horizontal: false, left_or_up: false))
            }
            //This view creates a very translucent rectangle that overlies the picture we'll be uploading
            Rectangle()
                .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification)
                .foregroundColor(Color.white.opacity(0.05))
                .offset(x: activeOffset.width, y: activeOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged{drag in
                            //Create an instance of the finalOffset + the change made via dragging - "workingOffset" will be used only for calcuations to determine if our drag should be "finalized"
                            let workingOffset = CGSize(
                                width: finalOffset.width + drag.translation.width,
                                height: finalOffset.height + drag.translation.height
                            )
                            
                            //First check if we are within the right and left bounds when translating in the horizontal dimension
                            if workingOffset.width + (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2) <= imageWidth/2 &&
                                (workingOffset.width - (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2)) >= -imageWidth/2 {
                                //If we are, then set the activeOffset.width equal to the workingOffset.width
                                self.activeOffset.width = workingOffset.width
                            } else if workingOffset.width + (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2) > imageWidth/2 {
                                //If we are at the right-most bound then align the right-most edges accordingly
                                self.activeOffset.width = (imageWidth/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2)
                            } else {
                                //If we are at the left-most bound then align the left-most edges accordingly
                                self.activeOffset.width = -(imageWidth/2) + (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2)
                            }
                            
                            //Next check if we are within the upper and lower bounds when translating in the vertical dimension
                            if workingOffset.height + (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2) <= imageHeight/2 &&
                                ((workingOffset.height) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2)) >= -imageHeight/2 {
                                //If we are, then set the activeOffset.height equal to the workingOffset.height
                                self.activeOffset.height = workingOffset.height
                            }
                            else if workingOffset.height + (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2) > imageWidth/2 {
                                //If we are at the bottom-most bound then align the bottom-most edges accordingly
                                self.activeOffset.height = (imageHeight/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2)
                            } else {
                                //If we are at the top-most bound then align the top-most edges accordingly
                                self.activeOffset.height = -((imageHeight/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight*0.999)/2))
                            }
                            
                        }
                        .onEnded{drag in
                            //Set the finalOffset equal to activeOffset; the whole point of this is that we use activeOffset to update the view, whereas finalOffset serves as the starting point for any calculations for each iteration of onChanged in a drag gesture
                            self.finalOffset = activeOffset
                        }
                )
            
            //These views create the white grid
            //This view creates the outer square
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification)
                .foregroundColor(.white)
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            //This view creates a thin rectangle in the center that is 1/3 the outer square's width
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification/3, height: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification)
                .foregroundColor(Color.white.opacity(0.6))
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            //This view creates a thin rectangle in the center that is 1/3 the outer square's height
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification/3)
                .foregroundColor(Color.white.opacity(0.6))
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            
            //UL corner icon
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(dotColor))
                .frame(width: dotSize, height: dotSize)
                .foregroundColor(.black)
                .offset(x: activeOffset.width - (activeMagnification*getDimension(w: imageWidth, h: imageHeight*0.999)/2), y: activeOffset.height - (activeMagnification*getDimension(w: imageWidth, h: imageHeight*0.999)/2))
                .padding(25)
                .gesture(
                    DragGesture()
                        .onChanged{drag in
                            //First it calculates the additional magnification this drag is proposing
                            let calcMag = getMagnification(drag.translation)
                            
                            //It then multiplies it against the magnification that was already present in your crop
                            let workingMagnification:CGFloat = finalMagnification * calcMag
                            
                            //**********************************
                            //This set of logic is used for calculations that prevent scaling to cause offset to go outside the actual image
                            //First we check the size of the offsets
                            let workingOffsetSize = (getDimension(w: imageWidth, h: imageHeight*0.999) * finalMagnification)-(getDimension(w: imageWidth, h: imageHeight*0.999) * activeMagnification)
                            
                            //Then we check the offset of the image barring the current "onChanged" we are currently experiencing by adding the proposed "workingOffsetSize" to the displayed "finalOffset"
                            let workingOffset = CGSize(width: finalOffset.width + workingOffsetSize/2, height: finalOffset.height + workingOffsetSize/2)
                            
                            //From here we calculate half the height of the original image and half the width, so we can use them to calculate if further scaling will extend our cropping view off the bounds of the screen
                            let halfImageHeight = self.imageHeight/2
                            let halfImageWidth = self.imageWidth/2
                            
                            //This variable is equal to half of the view finding square, factoring in the magnification
                            let proposed_halfSquareSize = (getDimension(w: imageWidth, h: imageHeight*0.999)*activeMagnification)/2
                            //**********************************
                            
                            //Here we are setting up the upper and lower limits of the magnificatiomn
                            if workingMagnification <= 1 && workingMagnification >= 0.4{
                                //If we fall within the scaling limits, then we will check that scaling would not extend the viewfinder past the bounds of the actual image
                                if proposed_halfSquareSize - workingOffset.height > halfImageHeight || proposed_halfSquareSize - workingOffset.width > halfImageWidth{
                                    print("scaling would extend past image bounds")
                                } else {
                                    activeMagnification = workingMagnification
                                }
                                
                            } else if workingMagnification > 1{
                                activeMagnification = 1
                            } else {
                                activeMagnification = 0.4
                            }
                            
                            
                            //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                            let offsetSize = (getDimension(w: imageWidth, h: imageHeight*0.999) * finalMagnification)-(getDimension(w: imageWidth, h: imageHeight*0.999) * activeMagnification)
                            
                            self.activeOffset.width = finalOffset.width + offsetSize/2
                            self.activeOffset.height = finalOffset.height + offsetSize/2
                        }
                        .onEnded{drag in
                            
                            //At the end you need to set the "final" variables equal to the "active" variables.
                            //The difference between these variables is that active is what is displayed, while final is what is used for calculations.
                            self.finalMagnification = activeMagnification
                            self.finalOffset = activeOffset
                            
                        }
                )
        }
        
    }
    
    
    
    //This function gets the offset for the surrounding views that obscure what has not been selected in the crop
    func getSurroundingViewOffsets(horizontal:Bool, left_or_up:Bool) -> CGFloat {
        let initialOffset:CGFloat = horizontal ? imageWidth : imageHeight
        let negVal:CGFloat = left_or_up ? -1 : 1
        let compensator = horizontal ? activeOffset.width : activeOffset.height
        
        return (((negVal * initialOffset) - (negVal * (initialOffset - getDimension(w: imageWidth, h: imageHeight*0.999))/2))/2) + (compensator/2) + (-negVal * (getDimension(w: imageWidth, h: imageHeight*0.999) * (1 - activeMagnification) / 4))
    }
    
    //This function determines the intended magnification you were going for. It does so by measuring the distance you dragged in both dimensions and comparing it against the longest edge of the image. The larger ratio is determined to be the magnification that you intended.
    func getMagnification(_ dragTranslation:CGSize) -> CGFloat {
        if (getDimension(w: imageWidth, h: imageHeight*0.999) - dragTranslation.width)/getDimension(w: imageWidth, h: imageHeight*0.999) < (getDimension(w: imageWidth, h: imageHeight*0.999) - dragTranslation.height)/getDimension(w: imageWidth, h: imageHeight*0.999) {
            return (getDimension(w: imageWidth, h: imageHeight*0.999) - dragTranslation.width)/getDimension(w: imageWidth, h: imageHeight*0.999)
        } else {
            return (getDimension(w: imageWidth, h: imageHeight*0.999) - dragTranslation.height)/getDimension(w: imageWidth, h: imageHeight*0.999)
        }
    }
    
    
}








//This function just gets the larger of two values, when comparing two inputs. It is typically executed by submitting a width and height of a view to return the larger of the two
func getDimension(w:CGFloat,h:CGFloat) -> CGFloat{
    if h > w {
        return w
    } else {
        return h
    }
    
}
