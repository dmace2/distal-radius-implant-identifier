//
//  ViewRouterClass.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import Foundation

enum ViewRouterOption {
    case onboarding
    case home
}




/**
 Creates the class responsible for choosing tutorial or home page on app opem
 */
class ViewRouter: ObservableObject {
    @Published var currentPage: ViewRouterOption
    
    /**
        As soon as you create the object it sets a public variable as onboarding or home. This variable used in the mother view to decide on app open.
     */
    init() {
        // Checks User Defaults for the boolean val, which gets set if onboarding finished for the first time.
        // See view 5 for setting
        if !UserDefaults.standard.bool(forKey: "LaunchBefore") {
            currentPage = .onboarding
        } else {
            currentPage = .home
        }
    }
    
    func setViewLaunch(_ view: ViewRouterOption) {
        self.currentPage = view
    }
    
}
