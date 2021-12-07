//
//  ResultsView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI
import Combine
//import SBPAsyncImage


struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @EnvironmentObject var classificationModel: ClassificationModel
    
    @State var classification: Classification?
    @State var rowTapped: Int = 0
    
    @State var userImage: Image? = Image("SampleXRay")
    @State var isPresented = false
    
    var body: some View {
        VStack {
            VStack() {
                HStack {
                    Spacer()
                    Text(classification?.results[0].company ?? "Result")
                        .font(.system(size: 50).weight(.bold))
                        .foregroundColor(Color("AccentLight"))
                    Spacer()
                }

                HStack {
                    Spacer()
                    Text(String(format: "%.2f", classification?.results[0].percentage ?? "00.00") + "%")
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .font(.system(size: 40))
                    Spacer()
                }

            }


            Spacer(minLength: 20)

            List {
                Section(header: Text("Images")) {
                    HStack(alignment: .center) {
                        ResultsImageView(image: userImage, caption: "Your Image")
                            .redacted(reason: classificationModel.isLoading ? .placeholder : [])

                        ResultsImageView(image: nil, url: classificationModel.getClassificationImageURL(company: classification?.results[0].company ?? ""),
                                         caption: (classification?.results[0].company ?? "Example") + " Image")
                            .redacted(reason: classificationModel.isLoading ? .placeholder : [])
                    }
                }

                Section(header: Text("Full Breakdown")) {
                    ForEach(Array(classification?.results.enumerated() ?? classificationModel.simulateResults().enumerated()), id: \.1.company) { (idx, row) in
                        ResultsItemView(row, color: Color("AccentLight"))
                            .padding(5)
                            .onTapGesture {
                                self.rowTapped = idx
                                self.isPresented.toggle()
                            }
                    }

                }
            }
            .listStyle(.sidebar)
//
            if UIDevice.current.userInterfaceIdiom == .phone  {
                RoundedButton(color: .accentColor, labelText: "Done", buttonFunc: {
                    NavigationUtil.popToRootView()
                })
                    .disabled(classificationModel.isLoading)
                    .padding()
            }
        }
        
        .redacted(reason: classificationModel.isLoading ? .placeholder : [])
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                InfoButtonView()
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)

        .sheet(isPresented: $isPresented) {
            NavigationView{
                CompanyDetailView(companyName: classification?.results[rowTapped].company ?? "Company")
                    .navigationBarTitle("Company Details")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
//
        
        .onAppear {
//            isLoading = classificationModel.isLoading
            Task {
                if classification == nil {
                    classification = await classificationModel.classifyImplant(image: cameraModel.capturedImage!)
                   
                }
                self.userImage = Image(classification!.image, scale: 1.0, label: Text("User Img"))
            }
        }
    }
}
//
//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
