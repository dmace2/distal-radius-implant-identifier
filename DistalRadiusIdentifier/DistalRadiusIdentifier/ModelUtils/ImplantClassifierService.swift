//
//  ImplantClassifierService.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 2/21/22.
//

import Foundation
import CoreML
import UIKit

class ClassifierService {
    
    static let shared = ClassifierService()
    
    private init() {
        
    }
    
    private let classifier: ImplantClassifier = {
        do {
            let config = MLModelConfiguration()
            return try ImplantClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create SleepCalculator")
        }
    }()
    
    func predict(image: UIImage) -> (Classification?, Error?) {
        print(image.size)
        
        do {
            let prediction = try ClassifierService.shared.classifier.prediction(image: image.cgImage!.pixelBuffer(width: 224, height: 224, orientation: .up)!)
            let predictedClass = prediction.classLabel
            let breakdown = prediction.breakdown
            print("PREDICTION: \(predictedClass)")
            
            var reshapedBreakdown: [CompanyPercentage] = []
            for (company, percentage) in breakdown {
                reshapedBreakdown.append(CompanyPercentage(company: company, percentage: Float(percentage*100)))
            }
            
            reshapedBreakdown = reshapedBreakdown.sorted {(first, second) -> Bool in return first.percentage > second.percentage}
            
            return (Classification(id: NSUUID().uuidString, results: reshapedBreakdown, predictedCompany: predictedClass,
                                   predictionConfidence: Float(breakdown[predictedClass]! * 100), image: image, date: Date()), nil)
        } catch {
            return (nil, error)
        }
    }
    
    func predict(images: [UIImage]) -> ([Classification]?, Error?) {
        var results: [Classification] = []
        for image in images {
            let (result, error) = predict(image: image)
            guard error == nil else {
                return (nil, error)
            }
            results.append(result!)
        }
        return (results, nil)
        
        
        
        
    }
}
