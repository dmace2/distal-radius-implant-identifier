//
//  ViewRouterClass.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import Foundation

/**
 Creates the class responsible for choosing tutorial or home page on app opem
 */
class ViewLaunch: ObservableObject {
    @Published var currentPage: String
    
    /**
        As soon as you create the object it sets a public variable as onboarding or home. This variable used in the mother view to decide on app open.
     */
    init() {
        // Checks User Defaults for the boolean val, which gets set if onboarding finished for the first time.
        // See view 5 for setting
        if !UserDefaults.standard.bool(forKey: "LaunchBefore") {
                currentPage = "onBoardingView"
        } else {
            currentPage = "HomeView"
        }
    }
    
}
