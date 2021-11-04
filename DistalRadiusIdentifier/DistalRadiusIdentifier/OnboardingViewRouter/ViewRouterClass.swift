//
//  ViewRouterClass.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import Foundation

class ViewRouter: ObservableObject {
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "homeView"
        }
    }
    
    @Published var currentPage: String
    
}
