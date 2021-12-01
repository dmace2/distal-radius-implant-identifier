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
    @State var doneBool = false
    
    @State var userImage: Image = Image("SampleXRay")
    @State var userImageTapped = false
    @State var exampleImage: Image = Image("SampleXRay")
    @State var exampleImageTapped = false
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    NavigationLink(destination: HomeView(),  isActive: $doneBool) {
                        EmptyView()
                    }
                    
                    
                    Spacer().frame(height: geo.size.height / 50)
                    
                    Text(classificationModel.results[0].company)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50).weight(.bold))
                        .foregroundColor(Color("TechBlue"))
                    
                    Text(String(format: "%.2f", classificationModel.results[0].percentage) + "%")
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
                        
                        ResultsImageView(image: exampleImage, caption: "\(classificationModel.results[0].company) Image").onTapGesture {
                            self.exampleImageTapped.toggle()
                        }
                        .fullScreenCover(isPresented: $exampleImageTapped) {
                            FullScreenImageView(image: exampleImage)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    List(classificationModel.results) { row in
                        ResultsItemView(row)
                    }
                    .listStyle(.plain)
                    
                    RoundedButton(color: Color("TechBlue"), labelText: "Done", buttonFunc: {
                        NavigationUtil.popToRootView()
                    })
                        .padding()
                }
            }
            .onAppear {
                self.userImage = Image(classificationModel.userImage!, scale: 1.0, label: Text("User Img"))
                self.exampleImage = Image("Example\(classificationModel.results[0].company)Image")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    InfoButtonView()
                }
            }
        }
    }
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
