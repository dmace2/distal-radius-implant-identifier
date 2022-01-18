//
//  ExampleImagesPageView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 1/18/22.
//

import SwiftUI

struct ExampleImagesPageView: View {
    @EnvironmentObject var model: CompanyDetailViewModel
    @State var images: [URL] = []
    
    var showTitle: Bool = true
    
    
    
    var body: some View {
        VStack {
            if showTitle {
                Text("\(model.companyName) Examples").font(.footnote)
                Spacer()
            }
            
            if images.count > 0 {
                TabView {
                    ForEach(images) { url in
                        ExpandingImageView(url: url)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            } else {
                ZStack {
                    Color.clear
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
