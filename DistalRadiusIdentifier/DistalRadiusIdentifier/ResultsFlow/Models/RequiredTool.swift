//
//  RequiredTool.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import Foundation

struct RequiredTool: Codable, Hashable {
    var toolName: String
    
}

struct TechniqueGuide: Codable, Hashable {
    var name: String
    var url: String
}

struct Example<Value:Hashable, Child:Hashable>: Hashable, Identifiable {
    var id: String = UUID().uuidString
    
    let value: Value
    var children: [Child]? = nil
}



struct ExampleImplant: Codable {
    var name: String
    var url: String
    var tools: [RequiredTool]
    
    
    
    
}
