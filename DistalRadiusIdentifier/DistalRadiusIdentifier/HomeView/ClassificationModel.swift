//
//  ClassificationModel.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import UIKit

struct Classification: Identifiable {
    var id = NSUUID().uuidString
    var results: [ResultsItem]
    var predictedCompany: String
    var predictionConfidence: Float
    var image: CGImage?
    var date: Date
}

struct CodableClassification: Identifiable, Codable {
    var id = NSUUID().uuidString
    var classifications: [ResultsItem]
    var predictedCompany: String
    var predictionConfidence: Float
    var date: String
}

@MainActor
class ClassificationModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var classifications: [Classification] = []
    
    var urlHostName = "http://128.61.11.110:33507"
    
    
    func simulateResults() -> [ResultsItem] {
        var results: [ResultsItem] = []
        let companies = ["Synthes", "Acumed", "Trimed"].shuffled()
        
        var sum: Float = 100
        for i in 0..<companies.count {
            let rand = Float.random(in: 0...sum)
            results.append(ResultsItem(company: companies[i], percentage: rand))
            sum -= rand
        }
        
        return results.sorted(by: { $0.percentage > $1.percentage})
    }

    func createRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
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
        var classification: Classification?

        
        
        
        
        // your image from Image picker, as of now I am picking image from the bundle
        let image = UIImage(cgImage: img)
        let imageData = image.pngData()

        let url =  "\(urlHostName)/predict"
        var urlRequest = URLRequest(url: URL(string: url)!)

        urlRequest.httpMethod = "post"
        let bodyBoundary = "\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")

//        //attachmentKey is the api parameter name for your image do ask the API developer for this
//       // file name is the name which you want to give to the file
        let requestData = createRequestBody(imageData: imageData!, boundary: bodyBoundary, attachmentKey: "file", fileName: "myTestImage.jpg")
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData
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

        } catch {
            print("Error: \(error.localizedDescription)")
        }
    
        isLoading = false
        return classification
    
        
        
        }

        func getBase64Image(image: CGImage, complete: @escaping (String?) -> ()) {
            DispatchQueue.main.async {
                let img = UIImage(cgImage: image)
                let imageData = img.pngData()
                let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
                complete(base64Image)
            }
        }
    
    
    
    
    func getClassificationImageURL(company: String) -> URL {
        return URL(string: "\(urlHostName)/companyExamples/\(company)")!
    }
    
    func getCompanyTechnigueGuideURL(company: String) -> URL {
        return URL(string: "http://www.google.com/search?q=\(company)")!
    }
    
    
    
    
    
}
