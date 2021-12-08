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
    @EnvironmentObject var classificationModel: ClassificationModel
    
    @State var presentingSafariView = false
    var companyName: String
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            AsyncImage(url: classificationModel.getClassificationImageURL(company: companyName)) { image in
                                image.resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: geo.size.width / 2)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(companyName)
                                .font(.largeTitle).foregroundColor(Color("AccentLight"))
                                .bold()
                        }
                        Spacer()
                    }
                    
                    Section {
                        Text("Tool 1")
                        Text("Tool 2")
                        Text("Tool 3")
                        
                    } header: {
                        Text("Required Tools")
                    }
                }
                .listStyle(.sidebar)
                
                Spacer()
                
                RoundedButton(labelText: "View Technique Guide", buttonFunc: {
                    self.presentingSafariView.toggle()
                })
                    .padding()
                    .sheet(isPresented: $presentingSafariView) {
                        SafariView(
                            url: classificationModel.getCompanyTechnigueGuideURL(company: companyName),
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                            .preferredControlAccentColor(.accentColor)
                            .dismissButtonStyle(.done)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
