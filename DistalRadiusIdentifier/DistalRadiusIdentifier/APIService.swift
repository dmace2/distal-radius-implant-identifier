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
    
    
    private func createPredictionRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Type: image/png \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
        requestBody.append(imageData)
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        return requestBody
    }
    
    func getImplantClassificationResults(from uiimage: UIImage) async -> (Classification?, Error?) {
        var classification: Classification?
        var classificationError: Error?
        
//        let uiimage = UIImage(cgImage: cgimage)
        let imageData = uiimage.pngData()
        
        let url =  URL(string: "\(urlHostName)/predict")
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "post"
        let bodyBoundary = "\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
        
        //attachmentKey is the api parameter name for your image DO NOT CHANGE
        // file name is the name which you want to give to the file
        let requestData = createPredictionRequestBody(imageData: imageData!, boundary: bodyBoundary, attachmentKey: "file", fileName: "predictionImage.png")
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData
        urlRequest.timeoutInterval = 5
        do {
            let (data, _) = try await self.session.upload(for: urlRequest, from: requestData)
            let decodedResults = try self.decoder.decode(CodableClassification.self, from: data)
            print(decodedResults)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            
            
            classification = Classification(results: decodedResults.classifications, predictedCompany: decodedResults.predictedCompany,
                                            predictionConfidence: decodedResults.predictionConfidence, image: uiimage,
                                            date: dateFormatter.date(from: decodedResults.date)!)
            
        } catch {
            classificationError = error
        }
        
        return (classification, classificationError)
    }
    
    func getImplantExamples(from company: String) async -> ([ExampleImplant]?, Error?) {
        var examples: [ExampleImplant]?
        var requestError: Error?
        
        
        let url = URL(string:"\(urlHostName)/implantExamples/\(company)")!
        
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
        
        
        let url = URL(string:"\(urlHostName)/companyExamples/\(company)")!
        
        do {
            session.configuration.timeoutIntervalForRequest = 5
            let (data, _) = try await self.session.data(from: url)
            let decodedData = try self.decoder.decode(Int.self, from: data)
            print(decodedData)
            for i in 1...decodedData {
                images.append(URL(string:"\(urlHostName)/companyExamples/\(company)/\(i)")!)
            }
            print(images)
            
        } catch {
            requestError = error
            print("ERROR: \(error)")
        }
        
        return (images, requestError)
        
    }
    
    
    
    
    
    
    
}
