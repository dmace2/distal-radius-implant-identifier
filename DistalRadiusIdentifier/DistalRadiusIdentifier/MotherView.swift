//
//  MotherView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct MotherView : View {
    @EnvironmentObject var viewlaunch: ViewRouter // get the view launch from the "environment"
    @State private var cameraModel = CameraFrameViewModel()
    
    var body: some View {
        
        VStack {
            if viewlaunch.currentPage == .onboarding { // pick which view to show based on what viewlaunch says
                TutorialPageContainerView()
            } else if viewlaunch.currentPage == .home {
                GeometryReader { geo in // this is a geometry reader. You use it to get the device size
                    NavigationView {
                        HomeView()
                            .environmentObject(cameraModel)
                            .navigationTitle("Home") // set nav title of home view
                        Text("View the Sidebar for Implant Classification History and New Classifications.")
                            .navigationTitle("Results")
                    }
                }
            }
        }
        
    }
}
