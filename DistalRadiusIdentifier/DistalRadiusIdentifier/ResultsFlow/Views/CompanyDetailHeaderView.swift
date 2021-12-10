//
//  CompanyDetailHeaderView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import SwiftUI

struct CompanyDetailHeaderView: View {
    var company: String
    var url: URL
    var width: CGFloat
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text(company)
                            .font(.largeTitle).foregroundColor(Color("AccentLight"))
                            .bold()
                        
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: width)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    Spacer()
                }
            }
    }
}

//struct CompanyDetailHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompanyDetailHeaderView()
//    }
//}
