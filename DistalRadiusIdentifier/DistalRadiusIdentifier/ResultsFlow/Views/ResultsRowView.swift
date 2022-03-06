//
//  ResultsItemView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsRowView: View {
    var item: CompanyPercentage
    var percentString: String
    var color: Color = .accentColor
    
    
    init(_ item: CompanyPercentage) {
        self.item = item
        
        if item.percentage < 1 {
            self.percentString = "<1.00%"
        } else {
            self.percentString = String(format: "%.2f", item.percentage) + "%"
        }
    }
    
    init(_ item: CompanyPercentage, color: Color) {
        self.init(item)
        self.color = color
    }
    
    
    
    
    @ViewBuilder
    var body: some View {
        
        HStack {
            Text(item.company)
            Spacer()
            Text(percentString).fontWeight(.bold).foregroundColor(color)
//            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }
}

struct ResultsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsRowView(CompanyPercentage(company: "Synthes", percentage: 95.91))
    }
}
