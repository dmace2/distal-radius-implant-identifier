//
//  ClassificationModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import SwiftUI


@MainActor
class ClassificationModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    @Published var classifications: [Classification] = []
    
    private let APISession = APIService.shared
    
    
    
    func classifyImplant(image img: UIImage) -> Classification? {
        isLoading = true
        error = nil
        
        let (classification, requestError) = ClassifierService.shared.predict(image: img)
        
        guard requestError == nil else {
            self.error = requestError
            return nil
        }
        
        classifications.append(classification!)
        isLoading = false
        
        return classification
    }
    
    func getClassificationImageURL(for company: String) -> URL {
        return URL(string: "\(APISession.urlHostName)/companyExamples/\(company)")!
    }
    
    func getCompanyTechnigueGuideURL(company: String) -> URL {
        return URL(string: "https://www.google.com/search?q=\(company)")!
    }
    
    
    
    
    
}
