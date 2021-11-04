//
//  DistalRadiusIdentifierApp.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

@main
struct DistalRadiusIdentifierApp: App {
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("TechBlue"))
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .environmentObject(ViewLaunch())
        }
    }
}
