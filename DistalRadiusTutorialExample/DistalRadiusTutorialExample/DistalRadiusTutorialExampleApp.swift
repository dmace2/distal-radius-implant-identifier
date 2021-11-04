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
}
