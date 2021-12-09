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
    var predictedCompany: String
    var predictionConfidence: Float
    var image: CGImage
    var date: Date
    
    
}

@MainActor
class ClassificationModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var classifications: [Classification] = []
//    @Published var image: CGImage?
    
    
    func simulateResults() -> [ResultsItem] {
        var results: [ResultsItem] = []
        let companies = ["Synthes", "Acumed", "Trimed"].shuffled()
        
        var sum: Float = 100
        for i in 0..<companies.count {
            let rand = Float.random(in: 0...sum)
            results.append(ResultsItem(company: companies[i], percentage: rand))
            sum -= rand
        }
        
        return results.sorted(by: { $0.percentage > $1.percentage})
    }
    
    
    func classifyImplant(image: CGImage) async -> Classification? {
        error = nil
        isLoading = true
        var classification: Classification?
        
        do {
            try await Task.sleep(nanoseconds: 2000000000) // wait 2 seconds
            let results = simulateResults()
            classification = Classification(results: results, predictedCompany: results[0].company,
                                            predictionConfidence: results[0].percentage, image: image, date: Date())
            //Classification(results: results, image: image, date: Date())
            classifications.append(classification!)
            //                throw "Test Error"
        }
        catch {
            self.error = error
            print("Error: \(error.localizedDescription)")
        }
        
        isLoading = false
        return classification
    }
    
    func getClassificationImageURL(company: String) -> URL {
        return URL(string: "http://172.20.10.7:33507/companyExamples/\(company)")!
    }
    
    func getCompanyTechnigueGuideURL(company: String) -> URL {
        return URL(string: "http://www.google.com/search?q=\(company)")!
    }
    
    
    
    
    
}
