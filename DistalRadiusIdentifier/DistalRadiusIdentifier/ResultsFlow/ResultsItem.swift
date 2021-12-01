//
//  ResultsItem.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import Foundation

struct ResultsItem: Codable, Identifiable {
    let id: String
    let company: String
    let percentage: Float
}
