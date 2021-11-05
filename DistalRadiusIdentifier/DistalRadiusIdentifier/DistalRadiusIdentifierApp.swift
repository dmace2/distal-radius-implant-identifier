//
//  DistalRadiusIdentifierApp.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

@main
struct DistalRadiusIdentifierApp: App {
    // This is the automatic file that is run when the app is launched
    
    var body: some Scene {
        WindowGroup { // creates a group of windows (for multi window)
            MotherView() // on load, show the motherview
                .environmentObject(ViewLaunch()) //pass it an environment object of a view launch
        }
    }
}
