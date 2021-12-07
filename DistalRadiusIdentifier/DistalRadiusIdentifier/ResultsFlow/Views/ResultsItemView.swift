//
//  ResultsItemView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsItemView: View {
    var item: ResultsItem
    var percentString: String
    
    
    init(_ item: ResultsItem) {
        self.item = item
        
        if item.percentage < 1 {
            self.percentString = "<1.00%"
        } else {
            self.percentString = String(format: "%.2f", item.percentage) + "%"
        }
    }
    
    
    @ViewBuilder
    var body: some View {
        
        
//
//        if #available(iOS 15, *) {
//            AnyView(HStack {
//                Text(item.company).badge(Text(percentString))
//                Image(systemName: "chevron.right").foregroundColor(.secondary)
//            })
//        } else {
//            // Fallback on earlier versions
//            HStack {
//                Text(item.company)
//                Spacer()
//                Text(percentString).fontWeight(.bold)
//                Image(systemName: "chevron.right").foregroundColor(.secondary)
//            }
//        }
        HStack {
            Text(item.company)
            Spacer()
            Text(percentString).fontWeight(.bold)
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }
}

struct ResultsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsItemView(ResultsItem(company: "Synthes", percentage: 95.91))
    }
}
