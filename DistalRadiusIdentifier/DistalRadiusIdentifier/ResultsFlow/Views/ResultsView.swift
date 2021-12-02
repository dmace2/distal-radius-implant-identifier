//
//  ResultsView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI
import HalfASheet

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var classificationModel: ClassificationModel
    
    @State var classification: Classification?
    
    
    @State var userImage: Image = Image("SampleXRay")
    @State var userImageTapped = false
    @State var exampleImage: Image = Image("SampleXRay")
    @State var exampleImageTapped = false
    
    @State var isPresented = false
    
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    if let classification = classification {
                        VStack() {
                            HStack {
                                Spacer()
                                Text(classification.results[0].company)
                                    .font(.system(size: 50).weight(.bold))
                                    .foregroundColor(Color("TechBlue"))
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Text(String(format: "%.2f", classification.results[0].percentage) + "%")
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .font(.system(size: 40))
                                Spacer()
                            }
                            
                        }
                        
                        Spacer(minLength: 20)
                        
                        List {
                            Section(header: Text("Images")) {
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
                                
                            }
                            Section(header: Text("Full Breakdown")) {
                                ForEach(classification.results) { row in
                                    ResultsItemView(row)
                                        .onTapGesture {
                                            self.isPresented.toggle()
                                        }
                                }
                                
                            }
                        }
                        .listStyle(.sidebar)
                        
                    }
                    
                    
                    
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        RoundedButton(color: Color("TechBlue"), labelText: "Done", buttonFunc: {
                            NavigationUtil.popToRootView()
                        })
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        InfoButtonView()
                    }
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView{
                CompanyDetailView(companyName: classification!.results[0].company)
                    .navigationBarTitle("Company Details")
                    .navigationBarTitleDisplayMode(.inline)
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
//
//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
