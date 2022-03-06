//
//  CompanyDetailView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI
import BetterSafariView

struct CompanyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var detailModel: CompanyDetailViewModel
    @State var presentingSafariView = false
    //    @State var rowTapped = 0
    
    @State var showingError = false
    
    var body: some View {
            VStack {
                HStack {
                    Text(detailModel.companyName).font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                ExampleImagesPageView(showTitle: false, detailedTitles: true)
                    .environmentObject(detailModel)
//                    .padding(.horizontal)
                
                List {
                    ForEach(Array(detailModel.examples.enumerated()), id: \.1.implantName) { idx,row in
                        Section {
                            DisclosureGroup {
                                ForEach(row.tools, id: \.toolName) { tool in
                                    //add toolview here
                                    Text(tool.toolName)
                                }
                                
                            } label: {
                                Text("Required Tools").bold()
                            }
                            Text("View Technique Guide")
                                .foregroundColor(row.techniqueGuide == nil ? .gray : .blue)
                                .onTapGesture {
                                    //                                        self.rowTapped = idx
                                    if row.techniqueGuide != nil {
                                        self.presentingSafariView.toggle()
                                    }
                                }
                                .disabled(row.techniqueGuide == nil)
                                .sheet(isPresented: $presentingSafariView) {
                                    SafariView(
                                        url: URL(string:row.techniqueGuide!)!,
                                        configuration: SafariView.Configuration(
                                            entersReaderIfAvailable: false,
                                            barCollapsingEnabled: true
                                        )
                                    )
                                    .preferredControlAccentColor(.accentColor)
                                    .dismissButtonStyle(.done)
                                }
                            
                        } header: {
                            Text(row.implantName)
                        }
                        
                    }
                }
                .onAppear {
                    getCompanyData()
                    print("EXAMPLES")
                    print(detailModel.examples)
                }
            }
            
        if let error = detailModel.error {
            ErrorView(error: "Failed to Collect Company Data")
                .unredacted()
                .alert(isPresented: $showingError, content: {
                    Alert(
                        title: Text("Error: \(error.localizedDescription)"),
                        message: Text("Try again or cancel this attempt?"),
                        primaryButton: .cancel(Text("Cancel"), action: {
                            NavigationUtil.popToRootView()
                        }),
                        secondaryButton: .default(Text("Retry"), action: {
                            getCompanyData()
                        })
                        
                    )
                })
            
            
        }
    }
    
    func getCompanyData() {
        Task {
            await detailModel.getImplantExamples()
            if detailModel.error != nil {
                self.showingError = true
            }
        }
    }
}
