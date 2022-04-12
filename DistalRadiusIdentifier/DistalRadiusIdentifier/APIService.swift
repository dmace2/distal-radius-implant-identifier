//
//  APIService.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 1/5/22.
//

import Foundation
import UIKit

class APIService {
    
    let urlHostName = "https://distalradius.herokuapp.com"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    static let shared = APIService()
    
    private init() {
        session.configuration.timeoutIntervalForRequest = 5
    }
    
    private func removeSpaces(from company: String) -> String {
        return company.replacingOccurrences(of: " ", with: "_")
    }
    
    func getImplantExamples(from company: String) async -> (CompanyImplants?, Error?) {
        var examples: CompanyImplants?
        var requestError: Error?
        
        let url = URL(string:"\(urlHostName)/implantExamples/\(removeSpaces(from: company))")!
        
        do {
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode(CompanyImplants.self, from: data)
            examples = decodedData
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (examples, requestError)
        
    }
    
    func getExampleImageURLs(from company: String) async -> ([ExampleImage], Error?) {
        var images: [ExampleImage] = []
        var requestError: Error?
        
        let url = URL(string:"\(urlHostName)/implantExamples/images/\(removeSpaces(from: company))")!
        
        do {
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode([ExampleImage].self, from: data)
            images = decodedData
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (images, requestError)
        
    }
    
    
    
    
    
    
    
}
