//
//  ExampleImagesPageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 1/18/22.
//

import SwiftUI

struct ExampleImagesPageView: View {
    @EnvironmentObject var model: CompanyDetailViewModel
    @State var images: [ImplantImage] = []
    
    var showTitle: Bool = true
    
    var detailedTitles: Bool = false
    
    
    var body: some View {
        VStack {
            if showTitle {
                Text("\(model.companyName) Examples").font(.footnote)
                Spacer()
            }
            
            if images.count > 0 {
                TabView {
                    ForEach(images, id: \.implantName) { example in
                        VStack {
                            if detailedTitles {
                                Text(example.implantName).bold()
                            }
                            ExpandingImageView(url: URL(string:example.imageURL)!)
                        }
                        .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            else {
                ZStack {
                    if !detailedTitles {
                        Color.clear
                    }
                    ProgressView()
                }
            }
        }
        .onAppear {
            Task {
                images = await (model.getImplantExampleImages() ?? [])
            }
        }
    }
}

//struct ExampleImagesPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExampleImagesPageView()
////            .environmentObject(CompanyDetailViewModel(companyName: "Synthes"))
//    }
//}
