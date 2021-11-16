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
            VStack {
                HStack {
                    Image("Logo").resizable()
                        .frame(width: geo.size.width / 5, height: geo.size.width / 5, alignment: .leading)
                    VStack(alignment: .leading) {
                        Text(title1).font(.headline)
                        if let subtitle1 = subtitle1 {
                            Text(subtitle1)
                        }
                        
                    }
                    .frame(width: geo.size.width * 0.6)
                }
                .padding()
                HStack {
                    VStack {
                        Rectangle()
                            .fill(Color(.displayP3, red: 1, green: 0, blue: 0, opacity: 0.7))
                            .frame(width: geo.size.width / 50, height: geo.size.width / 5, alignment: .center)
                    }
                    .frame(width: geo.size.width / 5, height: geo.size.width / 5, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(title2).font(.headline)
                        if let subtitle2 = subtitle1 {
                            Text(subtitle2)
                        }
                    }
                    .frame(width: geo.size.width * 0.6)
                }
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
    }
}

//struct AlignmentGuide_Previews: PreviewProvider {
//    static var previews: some View {
//        AlignmentGuideView()
//    }
//}
