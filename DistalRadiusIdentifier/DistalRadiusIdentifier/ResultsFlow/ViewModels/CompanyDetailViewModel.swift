//
//  CompanyDetailViewModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import Foundation
import SwiftUI


class CompanyDetailViewModel: ObservableObject {
    var urlHostName = "http://128.61.6.241:33507"
    
    var companyName: String
    @Published var examples: [ExampleImplant] = []
    
    @Published var error: Error?
    
    
    
    init(companyName: String) {
        self.companyName = companyName
    }

    
    func getClassificationImageURL() -> URL {
        return URL(string: "\(urlHostName)/companyExamples/\(companyName)")!
    }
    
    func getImplantExamples() async {
        let url = URL(string:"\(urlHostName)/implantExamples/\(companyName)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([ExampleImplant].self, from: data)
            self.examples = decodedData
            
        } catch {
            print(error.localizedDescription)
            self.error = error
        }
        
    }
}
