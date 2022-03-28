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
    // let urlHostName = "http://128.61.15.54:8000"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    static let shared = APIService()
    
    private init() {
        
    }
    
    private func removeSpaces(from company: String) -> String {
        return company.replacingOccurrences(of: " ", with: "_")
    }
    
    func getImplantExamples(from company: String) async -> (CompanyImplants?, Error?) {
        var examples: CompanyImplants?
        var requestError: Error?
        
        
        let url = URL(string:"\(urlHostName)/implantExamples/\(removeSpaces(from: company))")!
        
        do {
            session.configuration.timeoutIntervalForRequest = 5
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode(CompanyImplants.self, from: data)
            examples = decodedData
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (examples, requestError)
        
    }
    
    func getExampleImageURLs(from company: String) async -> ([ImplantImage], Error?) {
        var images: [ImplantImage] = []
        var requestError: Error?
        
        
        let url = URL(string:"\(urlHostName)/implantExamples/images/\(removeSpaces(from: company))")!
        
        do {
            session.configuration.timeoutIntervalForRequest = 5
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode([ImplantImage].self, from: data)
            print(decodedData)
            images = decodedData
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (images, requestError)
        
    }
    
    
    
    
    
    
    
}
