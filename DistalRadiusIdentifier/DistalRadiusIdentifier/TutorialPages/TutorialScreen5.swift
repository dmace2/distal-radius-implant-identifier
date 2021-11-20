//
//  TutorialScreen5.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI

struct TutorialScreen5: View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var tabSelection: Int
    @State var tag : Int? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack { // vertical stack
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width / 3)
                
                TutorialTitleAndSubheader(titleText: "Ready to \nGet Started?")
                
                Spacer()
    
                ArrowButton(buttonFunc: {
                    UserDefaults.standard.set(true, forKey: "LaunchBefore")
                    withAnimation(){
                        self.viewlaunch.currentPage = "HomeView"
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, labelText: "Finish Tutorial", arrow: false)
                
                
                Spacer().frame(height: 40)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
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
