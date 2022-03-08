//
//  ResultsItem.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation
import UIKit

struct IndividualCompanyResultsItem: Codable, Hashable {
    var company: String
    var percentage: Float
}

struct Classification: Identifiable {
    var id = NSUUID().uuidString
    var results: [IndividualCompanyResultsItem]
    var predictedCompany: String
    var predictionConfidence: Float
    var image: UIImage?
    var date: Date
}

struct CodableClassification: Identifiable, Codable {
    var id = NSUUID().uuidString
    var classifications: [IndividualCompanyResultsItem]
    var predictedCompany: String
    var predictionConfidence: Float
    var date: String
}

struct RequiredTool: Codable, Hashable {
    var toolName: String
    var toolURL: String?
}

struct ExampleImplant: Codable {
    var implantName: String
    var implantURL: String?
    var techniqueGuide: String?
    var tools: [RequiredTool]

}

struct ImplantImage: Codable {
    var implantName: String
    var imageURL: String
}

