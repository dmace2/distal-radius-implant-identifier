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
    
    @Published var examples: [ExampleImplant] = []
    @Published var error: Error?
    
    
    
    init(companyName: String) {
        self.companyName = companyName
    }

    
    func getImplantExamples() async {
        self.error = nil
        
        let (examples, error) = await APISession.getImplantExamples(from: companyName)
        
        guard error == nil else {
            self.error = error
            return
        }
        
        self.objectWillChange.send()
        self.examples = examples!
    }
    
    func getImplantExampleImages() async -> [ImplantImage]? {
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
