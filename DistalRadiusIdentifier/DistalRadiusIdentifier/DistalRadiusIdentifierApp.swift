//
//  DistalRadiusIdentifierApp.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

@main
struct DistalRadiusIdentifierApp: App {
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .environmentObject(ViewLaunch())
        }
    }
}
