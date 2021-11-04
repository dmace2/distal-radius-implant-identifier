//
//  MotherView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct MotherView : View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    
    var body: some View {
        
        VStack {
            if viewlaunch.currentPage == "onBoardingView" {
                TutorialPageContainerView()
            } else if viewlaunch.currentPage == "HomeView" {
                GeometryReader { geo in
                    NavigationView {
                        HomeView()
                            .navigationTitle("Home")
                        Text("View the Sidebar for Implant Classification History and New Classifications.")
                            .navigationTitle("Results")
                    }
                    .padding(.leading, geo.size.height > geo.size.width ? 1 : 0)
                }
            }
        }
        
    }
}
