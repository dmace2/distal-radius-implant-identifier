//
//  AlignmentGuide.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/15/21.
//

import SwiftUI

struct AlignmentGuideView: View {
    var title1: String
    var subtitle1: String?
    var title2: String
    var subtitle2: String?
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image("ViewFinder")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: geo.size.width / 10, height: geo.size.width / 10, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(title1).font(.headline)
                        if let subtitle2 = subtitle1 {
                            Text(subtitle2)
                        }
                    }
                }
                .padding(.bottom, 10)
                
                HStack(alignment: .center) {
                    VStack {
                        Rectangle()
                            .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.7))
                            .frame(width: geo.size.width / 50, height: geo.size.width / 10, alignment: .center)
                    }
                    .frame(width: geo.size.width / 10)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(title2).font(.headline)
                        if let subtitle2 = subtitle2 {
                            Text(subtitle2)
                        }
                    }
                }
                
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
    }
}

struct AlignmentGuide_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentGuideView(title1: "Get Close",
                           subtitle1: "Fit plate closely within bounds",
                           title2: "Line Up",
                           subtitle2: "Center plate along red line"
        )
    }
}
