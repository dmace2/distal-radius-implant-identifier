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
    
    
    
    var body: some View {
        
        
        
        
        if #available(iOS 15.0, *) {
            Text(item.company).badge(Text(percentString))
        } else {
            // Fallback on earlier versions
            Text(item.company)
            Spacer()
            Text(percentString).fontWeight(.bold)
        }
    }
}

struct ResultsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsItemView(ResultsItem(id: String.random(), company: "Synthes", percentage: 95.91))
    }
}
