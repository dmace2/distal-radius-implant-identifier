//
//  DistalRadiusTutorialExampleApp.swift
//  DistalRadiusTutorialExample
//
//  Created by Dylan Mace on 10/25/21.
//

import SwiftUI

@main
struct DistalRadiusTutorialExampleApp: App {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("TechBlue"))
    }
    @State private var tabSelection = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                WelcomePage1(tabSelection: $tabSelection).tag(1)
                WelcomePage2(tabSelection: $tabSelection).tag(2)
                WelcomePage3(tabSelection: $tabSelection).tag(3)
                WelcomePage4(tabSelection: $tabSelection).tag(4)
                WelcomePage5(tabSelection: $tabSelection).tag(5)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}
