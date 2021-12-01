//
//  ClassificationModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import SwiftUI

class ClassificationModel: ObservableObject {
    @Published var results: [ResultsItem] = []
    var userImage: CGImage?
    
    init() {
        simulateResults()
        
    }
    
    func simulateResults() {
        var sum: Float = 100
        for _ in 0...15 {
            let rand = Float.random(in: 0...sum)
            self.results.append(ResultsItem(id: NSUUID().uuidString, company: "Synthes", percentage: rand))
            sum -= rand
        }
        self.results = results.sorted(by: { $0.percentage > $1.percentage})
    }
    
    
    
    
}
