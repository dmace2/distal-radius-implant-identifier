//
//  ResultsItem.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import UIKit

struct ResultsItem: Codable, Hashable {
//    let id: String
    let company: String
    let percentage: Float
}

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
