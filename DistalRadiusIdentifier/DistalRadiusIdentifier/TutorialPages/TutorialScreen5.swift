//
//  TutorialScreen5.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen5: View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    
    @Binding var tabSelection: Int
    @State var tag : Int? = nil
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TutorialTitleAndSubheader(titleText: "Ready to \nGet Started?")
            
            
            Spacer()
            
            
            
//            NavigationLink(destination: MotherView()) {
                ArrowButton(buttonFunc: {
                    UserDefaults.standard.set(true, forKey: "LaunchBefore")
                                    withAnimation(){
                                        self.viewlaunch.currentPage = "HomeView"
                                    }
//                    ViewRouter().setFinishedTutorial()
                }, labelText: "Finish Tutorial", arrow: false)
//            }
            
            
            Spacer().frame(height: 40)
            
        }
        .padding()
    }
}
//
//struct WelcomeScreen5_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeScreen5()
//    }
//}
