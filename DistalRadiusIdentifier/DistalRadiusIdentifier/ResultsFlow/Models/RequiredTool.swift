//
//  RequiredTool.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import Foundation

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
