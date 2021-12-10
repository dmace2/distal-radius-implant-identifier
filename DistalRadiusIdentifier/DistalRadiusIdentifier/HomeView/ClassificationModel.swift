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
    
    var urlHostName = "http://128.61.6.241:33507"

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

    func classifyImplant(image img: CGImage) async -> Classification? {
        isLoading = true
        error = nil
        var classification: Classification?
        
        let image = UIImage(cgImage: img)
        let imageData = image.pngData()

        let url =  "\(urlHostName)/predict"
        var urlRequest = URLRequest(url: URL(string: url)!)

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
            let (data, _) = try await URLSession.shared.upload(for: urlRequest, from: requestData)
            let decodedResults = try JSONDecoder().decode(CodableClassification.self, from: data)
            print(decodedResults)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            
            
            classification = Classification(results: decodedResults.classifications, predictedCompany: decodedResults.predictedCompany,
                                            predictionConfidence: decodedResults.predictionConfidence, image: img,
                                            date: dateFormatter.date(from: decodedResults.date)!)
            classifications.append(classification!)
            isLoading = false

        } catch {
            self.error = error
            print("Error: \(error.localizedDescription)")
        }
        
        return classification
    }
    
    func getClassificationImageURL(company: String) -> URL {
        return URL(string: "\(urlHostName)/companyExamples/\(company)")!
    }
    
    func getCompanyTechnigueGuideURL(company: String) -> URL {
        return URL(string: "http://www.google.com/search?q=\(company)")!
    }
    
    
    
    
    
}
