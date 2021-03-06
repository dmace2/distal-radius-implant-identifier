//
//  ResultsView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI
import Combine

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cameraModel: CameraFrameViewModel
    @EnvironmentObject var classificationModel: ClassificationModel
    
    @State var classification: Classification?
    @State var rowTapped: Int = 0
    
    @State var userImage: Image? = Image("SampleXRay")
    @State var isPresented = false
    @State var showingError = false
    
    var body: some View {
        ZStack {
            
            VStack {
                
                
                VStack() {
                    HStack {
                        Spacer()
                        Text(classification?.predictedCompany ?? "Result")
                            .font(.system(size: 50).weight(.bold))
                            .foregroundColor(Color("AccentLight"))
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text(String(format: "%.2f", classification?.predictionConfidence ?? "00.00") + "%")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .font(.system(size: 40))
                        Spacer()
                    }
                    
                }
                
                
                Spacer(minLength: 20)
                
                List {
                    Section(header: Text("Images")) {
                        HStack(alignment: .center) {
                            ExpandingImageView(caption: "Your Image", image: userImage)
                            if let company = classification?.predictedCompany {
                                ExampleImagesPageView().environmentObject(CompanyDetailViewModel(companyName: company))
                            } else {
                                ZStack {
                                    Color.clear
                                    ProgressView()
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Full Breakdown")) {
                        ForEach(Array(classification?.results.enumerated() ?? [].enumerated()), id: \.1.company) { (idx, row) in
                            NavigationLink(destination: CompanyDetailView(detailModel: CompanyDetailViewModel(companyName: row.company))) {
                                ResultsRowView(row, color: Color("AccentLight"))
                                    .padding(5)
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
                
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
            
            if let error = classificationModel.error {
                ErrorView(error: "Classification Failed")
                    .unredacted()
                    .alert(isPresented: $showingError, content: {
                        Alert(
                            title: Text("Error: \(error.localizedDescription)"),
                            message: Text("Try again or cancel this attempt?"),
                            primaryButton: .cancel(Text("Cancel"), action: {
                                NavigationUtil.popToRootView()
                            }),
                            secondaryButton: .default(Text("Retry"), action: {
                                getClassificationResults()
                            })
                            
                        )
                    })
            }
        }
        
        .onAppear {
            if classification == nil {
                getClassificationResults()
            }
            else {
                classificationModel.error = nil
                classificationModel.isLoading = false
                userImage = Image(uiImage: classification!.image!)
            }
        }
    }
    
    func getClassificationResults() {
        classification = classificationModel.classifyImplant(image: cameraModel.capturedImage!)
        
        if classificationModel.error == nil {
            self.userImage = Image(uiImage: classification!.image!)
        } else {
            self.showingError = true
        }
    }
    
    
    
    
}
//
//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
