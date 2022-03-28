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
    @State var safariViewURL: String?
    //    @State var rowTapped = 0
    
    @State var showingError = false
    
    var body: some View {
            VStack {
                HStack {
                    Text(detailModel.companyName).font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                
                List {
                    Section {
                        ExampleImagesPageView(collectionTitle: false, individualTitles: true)
                            .frame(minHeight: 200)
                            .environmentObject(detailModel)
                    } header: {
                        Text("Implant Example Images")
                    }
                    
                    
                    Section {
                        if detailModel.examples?.companywide_guides.count != 0 {
                            ForEach(Array(detailModel.examples?.companywide_guides.enumerated() ?? [].enumerated()), id: \.1.urlString) { idx,row in
                                Text("View \(detailModel.convertGuideType(row.type)) Guide")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.safariViewURL = row.urlString
                                        self.presentingSafariView.toggle()
                                    }
                                    
                            }
                        } else {
                            Text("No Guides to Display")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        
                    } header: {
                        Text("Company-Wide Guide Documents")
                    }
                    
                    
                    ForEach(Array(detailModel.examples?.implants.enumerated() ?? [].enumerated()), id: \.1.implantName) { idx,row in
                        Section {
                            if row.guides.count > 0 {
                                ForEach(row.guides, id: \.urlString) { guide in
                                    Text("View \(detailModel.convertGuideType(guide.type)) Guide")
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            self.safariViewURL = guide.urlString
                                            self.presentingSafariView.toggle()
                                        }

                                }
                                
                            } else {
                                Text("No Guides to Display")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }

                        } header: {
                            Text(row.implantName)
                        }
                        
                    }
                }
                .sheet(isPresented: $presentingSafariView) {
                    if self.safariViewURL != nil {
                        SafariView(
                            url: URL(string:self.safariViewURL!)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
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
