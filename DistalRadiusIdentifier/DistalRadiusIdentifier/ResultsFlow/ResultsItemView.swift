//
//  ResultsItemView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsItemView: View {
    var item: ResultsItem
    
    init(_ item: ResultsItem) {
        self.item = item
    }
    
    
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Text(item.companyName).badge(Text(String(item.percentage) + "%"))
        } else {
            // Fallback on earlier versions
            Text(item.companyName)
            Spacer()
            Text(String(item.percentage) + "%").fontWeight(.bold)
        }
    }
}

struct ResultsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
    }
}
