//
//  ResultsView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var classificationModel: ClassificationModel
    
    @State var classification: Classification?
    
    
    @State var userImage: Image = Image("SampleXRay")
    @State var userImageTapped = false
    @State var exampleImage: Image = Image("SampleXRay")
    @State var exampleImageTapped = false
    
    
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer().frame(height: geo.size.height / 50)
                    
                    if let classification = classification {
                    
                        Text(classification.results[0].company)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 50).weight(.bold))
                            .foregroundColor(Color("TechBlue"))
                        
                        Text(String(format: "%.2f", classification.results[0].percentage) + "%")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.system(size: 40))
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            ResultsImageView(image: userImage, caption: "Your Image").onTapGesture {
                                self.userImageTapped.toggle()
                            }
                            .fullScreenCover(isPresented: $userImageTapped) {
                                FullScreenImageView(image: userImage)
                            }
                            
                            ResultsImageView(image: exampleImage, caption: "\(classification.results[0].company) Image").onTapGesture {
                                self.exampleImageTapped.toggle()
                            }
                            .fullScreenCover(isPresented: $exampleImageTapped) {
                                FullScreenImageView(image: exampleImage)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        List(classification.results) { row in
                            ResultsItemView(row)
                        }
                        .listStyle(.plain)
                        
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            RoundedButton(color: Color("TechBlue"), labelText: "Done", buttonFunc: {
                                NavigationUtil.popToRootView()
                            })
                                .padding()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        InfoButtonView()
                    }
                }
            }
        }
        .onAppear {
            if classification == nil {classification = classificationModel.classifications.last}
            self.userImage = Image(classification!.image, scale: 1.0, label: Text("User Img"))
            self.exampleImage = Image("Example\(classification!.results[0].company)Image")
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
