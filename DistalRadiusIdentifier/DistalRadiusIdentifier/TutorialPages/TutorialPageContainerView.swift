//
//  TutorialPageContainerVjew.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialPageContainerView: View {
    @EnvironmentObject var viewlaunch: ViewLaunch

    @State private var tabSelection = 1
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("TechBlue"))
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            TutorialScreen1(tabSelection: $tabSelection).tag(1)
            TutorialScreen2(tabSelection: $tabSelection).tag(2)
            TutorialScreen3(tabSelection: $tabSelection).tag(3)
            TutorialScreen4(tabSelection: $tabSelection).tag(4)
            TutorialScreen5(tabSelection: $tabSelection).tag(5)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
    }
}

