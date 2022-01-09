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
    @State var detailModel: CompanyDetailViewModel
    @State var presentingSafariView = false
    @State var rowTapped = 0
    
    @State var showingError = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    CompanyDetailHeaderView(company: detailModel.companyName,
                                            url: detailModel.getClassificationImageURL(), width: geo.size.width / 2)
                    .padding()
                    
                    List {
                        ForEach(Array(detailModel.examples.enumerated()), id: \.1.name) { idx,row in
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
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                    self.rowTapped = idx
                                    self.presentingSafariView.toggle()
                                }
                                .sheet(isPresented: $presentingSafariView) {
                                    SafariView(
                                        url: URL(string:detailModel.examples[rowTapped].url)!,
                                        configuration: SafariView.Configuration(
                                            entersReaderIfAvailable: false,
                                            barCollapsingEnabled: true
                                        )
                                    )
                                        .preferredControlAccentColor(.accentColor)
                                        .dismissButtonStyle(.done)
                                }
                                
                            } header: {
                                Text(row.name)
                            }
                            
                        }
                    }
                    .listStyle(.sidebar)
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
        .onAppear {
            getCompanyData()
        }
        .navigationBarTitle("Company Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
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
