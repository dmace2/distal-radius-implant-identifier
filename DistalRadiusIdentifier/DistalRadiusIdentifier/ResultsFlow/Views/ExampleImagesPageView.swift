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
    
    var collectionTitle: Bool = true
    var individualTitles: Bool = false
    
    
    var body: some View {
        VStack {
            if collectionTitle {
                Text("\(model.companyName) Examples").font(.footnote)
                Spacer()
            }
            
            if images.count > 0 {
                TabView {
                    ForEach(images, id: \.implantName) { example in
                        VStack {
                            if individualTitles {
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
                    if !individualTitles {
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
