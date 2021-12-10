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
    @Published var tools: [RequiredTool] = []
    @Published var examples: [ExampleImplant] = []
    @Published var techniqueGuides: [TechniqueGuide] = []
    
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
//            return decodedData
            
        } catch {
//            print(error.localizedDescription)
            self.error = error
//            return []
        }
        
    }
    
    
    
    
    
    func getRequiredTools() async {
        let url = URL(string:"\(urlHostName)/requiredTools/\(companyName)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([RequiredTool].self, from: data)
            self.tools = decodedData
//            return decodedData
            
        } catch {
//            print(error.localizedDescription)
            self.error = error
//            return []
        }

        
    }
    
    func getCompanyTechniqueGuides() async {
        let url = URL(string:"\(urlHostName)/techniqueGuides/\(companyName)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([TechniqueGuide].self, from: data)
            self.techniqueGuides = decodedData
            //return decodedData
            
        } catch {
//            print(error.localizedDescription)
            self.error = error
            //return []//
        }

    }
    
    
    func getCompanyTechnigueGuideURL() -> URL {
        return URL(string: "\(urlHostName)/techniqueGuide/\(companyName)")!
    }
    
    
    
    
    
}
