//
//  CompanyDetailViewModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import Foundation
import SwiftUI

@MainActor
class CompanyDetailViewModel: ObservableObject {
    
    private let APISession = APIService.shared
    var companyName: String
    
    @Published var examples: CompanyImplants? = CompanyImplants(companywide_guides: [], implants: [])
    @Published var error: Error?
    
    
    init(companyName: String) {
        self.companyName = companyName
    }
    
    func convertGuideType(_ type: String) -> String {
        return type.replacingOccurrences(of: "_", with: " ").capitalized
    }

    
    func getImplantExamples() async {
        self.error = nil
        
        let (examples, error) = await APISession.getImplantExamples(from: companyName)
        
        guard error == nil else {
            self.error = error
            return
        }
        
        self.objectWillChange.send()
        self.examples = examples
    }
    
    func getImplantExampleImages() async -> [ExampleImage]? {
        self.error = nil
        
        let (examples, error) = await APISession.getExampleImageURLs(from: companyName)
        
        guard error == nil else {
            self.error = error
            return nil
        }
        
        self.objectWillChange.send()
        return examples
    }
}
