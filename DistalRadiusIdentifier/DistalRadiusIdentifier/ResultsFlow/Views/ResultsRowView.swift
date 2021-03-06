//
//  ResultsItemView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsRowView: View {
    var item: IndividualCompanyResultsItem
    var percentString: String
    var color: Color = .accentColor
    
    
    init(_ item: IndividualCompanyResultsItem) {
        self.item = item
        
        if item.percentage < 1 {
            self.percentString = "<1.00%"
        } else {
            self.percentString = String(format: "%.2f", item.percentage) + "%"
        }
    }
    
    init(_ item: IndividualCompanyResultsItem, color: Color) {
        self.init(item)
        self.color = color
    }
    
    @ViewBuilder
    var body: some View {
        
        HStack {
            Text(item.company)
            Spacer()
            Text(percentString).fontWeight(.bold).foregroundColor(color)
        }
    }
}

struct ResultsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsRowView(IndividualCompanyResultsItem(company: "Synthes", percentage: 95.91))
    }
}
