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
    
//    init() {
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
////            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
////            UINavigationBar.appearance().barStyle = .default
//        }
//    }
    
    var body: some Scene {
        WindowGroup { // creates a group of windows (for multi window)
            MotherView() // on load, show the motherview
                .environmentObject(ViewRouter()) //pass it an environment object of a view launch
                .environmentObject(CameraFrameViewModel())
                .environmentObject(ClassificationModel())
        }
    }
}
