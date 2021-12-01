//
//  ClassificationModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import UIKit

struct Classification: Identifiable {
    var id = NSUUID().uuidString
    var results: [ResultsItem]
    var image: CGImage
    
}


class ClassificationModel: ObservableObject {
    @Published var classifications: [Classification] = []
    
    
    func simulateResults() -> [ResultsItem] {
        var results: [ResultsItem] = []
        
        var sum: Float = 100
        for _ in 0...15 {
            let rand = Float.random(in: 0...sum)
            results.append(ResultsItem(id: NSUUID().uuidString, company: "Synthes", percentage: rand))
            sum -= rand
        }
        return results.sorted(by: { $0.percentage > $1.percentage})
    }
    
    
    func classifyImplant(image: CGImage, completion: @escaping (Error?) -> Void) {
        let classResults = simulateResults()
        classifications.append(Classification(results: classResults, image: image))
        completion(nil)
        
    }
    
    
    
}
