//
//  MotherView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct MotherView : View {
    @EnvironmentObject var viewlaunch: ViewLaunch // get the view launch from the "environment"
    
    var body: some View {
        
        VStack {
            if viewlaunch.currentPage == "onBoardingView" { // pick which view to show based on what viewlaunch says
                TutorialPageContainerView()
            } else if viewlaunch.currentPage == "HomeView" {
                GeometryReader { geo in // this is a geometry reader. You use it to get the device size
                    NavigationView {
                        HomeView()
                            .navigationTitle("Home") // set nav title of home view
                        Text("View the Sidebar for Implant Classification History and New Classifications.")
                            .navigationTitle("Results")
                    }
                    .padding(.leading, geo.size.height > geo.size.width ? 1 : 0) // set padding depending on orientation
                }
            }
        }
        
    }
}
