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
    private let MLSession = ClassifierService.shared
    
    
    func classifyImplant(image img: UIImage) -> Classification? {
        isLoading = true
        error = nil
        
        let (classification, requestError) = MLSession.predict(image: img)
        
        guard requestError == nil else {
            self.error = requestError
            return nil
        }
        
        classifications.append(classification!)
        isLoading = false
        
        return classification
    }
    
}
