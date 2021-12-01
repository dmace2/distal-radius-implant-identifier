//
//  HomeView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/3/21.
//

import SwiftUI
//import CameraView


/**
 This is going to be the view for the home page
 */
struct HomeView: View {
    @State private var cameraModel = CameraFrameViewModel()
    @State var classify = false
    
    @State var showTutorial = false
    @State var showFAQ = false
    
    var body: some View {
        VStack {
            List {
                
            }
            Spacer()
            NavigationLink(destination: TakePhotoView().environmentObject(cameraModel).navigationTitle("Take Implant Photo"), isActive: $classify) {
                RoundedButton(color: Color("TechBlue"), labelText: "Classify Implant", buttonFunc: {self.classify = true})
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                InfoButtonView()
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
