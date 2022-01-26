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
    
    @State var showingError = false
    
    var body: some View {
        ZStack {
            
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
                            ExpandingImageView(caption: "Your Image", image: userImage)
                            if let company = classification?.predictedCompany {
                                ExampleImagesPageView()
                                    .environmentObject(CompanyDetailViewModel(companyName: company))
                            } else {
                                ZStack {
                                    Color.clear
                                    ProgressView()
                                }
                            }
                        }
//                        ExampleImagesPageView()
                    }
                    
                    Section(header: Text("Full Breakdown")) {
                        ForEach(Array(classification?.results.enumerated() ?? [].enumerated()), id: \.1.company) { (idx, row) in
                            ResultsRowView(row, color: Color("AccentLight"))
                                .padding(5)
                                .onTapGesture {
                                    if !classificationModel.isLoading {
                                        self.rowTapped = idx
                                        self.isPresented.toggle()
                                    }
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
                    //.unredacted()
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
                    CompanyDetailView(detailModel: CompanyDetailViewModel(companyName: classification?.results[rowTapped].company ?? "Company"))
                    //.environmentObject(CompanyDetailViewModel(companyName: classification?.results[rowTapped].company ?? "Company"))
                }
            }
            
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
        Task {
            classification = await classificationModel.classifyImplant(image: cameraModel.capturedImage!)
            
            if classificationModel.error == nil {
                self.userImage = Image(uiImage: classification!.image!)
            } else {
                self.showingError = true
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
