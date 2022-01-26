//
//  ResultsItem.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import UIKit

struct CompanyPercentage: Codable, Hashable {
    let company: String
    let percentage: Float
}

struct Classification: Identifiable {
    var id = NSUUID().uuidString
    var results: [CompanyPercentage]
    var predictedCompany: String
    var predictionConfidence: Float
    var image: UIImage?
    var date: Date
}

struct CodableClassification: Identifiable, Codable {
    var id = NSUUID().uuidString
    var classifications: [CompanyPercentage]
    var predictedCompany: String
    var predictionConfidence: Float
    var date: String
}
