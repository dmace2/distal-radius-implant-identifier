//
//  ViewRouterClass.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import Foundation

class ViewLaunch: ObservableObject {

    init() {
        if !UserDefaults.standard.bool(forKey: "LaunchBefore") {
                currentPage = "onBoardingView"
        } else {
            currentPage = "HomeView"
        }
    }
    @Published var currentPage: String
}
