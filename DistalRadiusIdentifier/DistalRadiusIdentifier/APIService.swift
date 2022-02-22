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
        
    }
    
    private func removeSpaces(from company: String) -> String {
        return company.replacingOccurrences(of: " ", with: "_")
    }
    
    func getImplantExamples(from company: String) async -> ([ExampleImplant]?, Error?) {
        var examples: [ExampleImplant]?
        var requestError: Error?
        
        
        let url = URL(string:"\(urlHostName)/implantExamples/\(removeSpaces(from: company))")!
        
        do {
            session.configuration.timeoutIntervalForRequest = 5
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode([ExampleImplant].self, from: data)
            examples = decodedData
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (examples, requestError)
        
    }
    
    func getExampleImageURLs(from company: String) async -> ([URL], Error?) {
        var images: [URL] = []
        var requestError: Error?
        
        
        let url = URL(string:"\(urlHostName)/companyExamples/\(removeSpaces(from: company))")!
        
        do {
            session.configuration.timeoutIntervalForRequest = 5
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode(Int.self, from: data)
            print(decodedData)
            for i in 1...decodedData {
                images.append(URL(string:"\(urlHostName)/companyExamples/\(removeSpaces(from: company))/\(i)")!)
            }
            print(images)
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (images, requestError)
        
    }
    
    
    
    
    
    
    
}
