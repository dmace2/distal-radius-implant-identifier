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
            classification = Classification(results: results, image: image, date: Date())
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
        return URL(string: "https://media.wired.com/photos/5b899992404e112d2df1e94e/master/pass/trash2-01.jpg")!
    }
    
    func getCompanyTechnigueGuideURL(company: String) -> URL {
        return URL(string: "https://www.google.com/search?q=\(company)")!
    }
    
    
    
    
    
}
