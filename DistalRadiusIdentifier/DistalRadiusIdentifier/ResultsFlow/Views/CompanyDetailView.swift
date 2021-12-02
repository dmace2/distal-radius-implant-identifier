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
    @State var presentingSafariView = false
    var companyName: String
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            Image("Example\(companyName)Image")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: geo.size.width / 2)
                            Text(companyName)
                                .font(.largeTitle).foregroundColor(Color("TechBlue"))
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
                RoundedButton(color: Color("TechBlue"), labelText: "View Company Manual", buttonFunc: {
                    self.presentingSafariView.toggle()
                })
                    .padding()
                    .sheet(isPresented: $presentingSafariView) {
                        SafariView(
                            url: URL(string: "https://google.com")!,
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
