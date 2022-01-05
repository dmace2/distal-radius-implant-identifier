//
//  RequiredTool.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/10/21.
//

import Foundation

struct RequiredTool: Codable, Hashable {
    var toolName: String
    /*
     Expand this later when we get more information
     */
}


struct ExampleImplant: Codable {
    var name: String
    var url: String
    var tools: [RequiredTool]
    
    
    
    
}
