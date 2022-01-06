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
                            ExpandingImageView(image: userImage, caption: "Your Image")
                                .redacted(reason: classificationModel.isLoading ? .placeholder : [])

                            ExpandingImageView(image: nil, url: classificationModel.getClassificationImageURL(for: classification?.results[0].company ?? ""),
                                               caption: (classification?.results[0].company ?? "Example") + " Image")
                                .redacted(reason: classificationModel.isLoading ? .placeholder : [])
                        }
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
//                withAnimation {
                    if #available(iOS 15.0, *) {
                        ErrorView(error: "Classification Failed")
                            .alert("Error: \(error.localizedDescription)", isPresented: $showingError, actions: {
                                Button("Cancel", role: .cancel) { NavigationUtil.popToRootView() }
                                Button("Retry") { getClassificationResults() }
                            }, message: {
                                Text("Try again or cancel this attempt?")
                            })
                        
                            .unredacted()
                    } else {
                        // Fallback on earlier versions
                        ErrorView(error: "Classification Failed")
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
                            .unredacted()
                    }
//                }
            }
        }
        
        .onAppear {
            if classification == nil {
                getClassificationResults()
            }
            else {
                classificationModel.error = nil
                classificationModel.isLoading = false
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
