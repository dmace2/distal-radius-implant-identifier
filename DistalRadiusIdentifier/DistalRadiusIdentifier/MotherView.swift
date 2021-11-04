//
//  MotherView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct MotherView : View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                TutorialPageContainerView()
            } else if viewRouter.currentPage == "homeView" {
                HomeView()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
