//
//  CompanyDetailHeaderView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import SwiftUI

struct CompanyDetailHeaderView: View {
    var company: String
    var width: CGFloat
    
    @EnvironmentObject var model: CompanyDetailViewModel
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text(company)
                            .font(.largeTitle).foregroundColor(Color("AccentLight"))
                            .bold()
                        
                        ExampleImagesPageView(showTitle: false).environmentObject(model)
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
