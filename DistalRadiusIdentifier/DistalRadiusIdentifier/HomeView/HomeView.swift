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
<<<<<<< HEAD
    @State private var cameraModel = CameraFrameViewModel()
    @State var classify = false
    
    var body: some View {
        VStack {
            List {
                
            }
            Spacer()
            NavigationLink(destination: TakePhotoView().environmentObject(cameraModel).navigationTitle("Take Implant Photo"), isActive: $classify) {
                ArrowButton(buttonFunc: {self.classify = true}, labelText: "Classify Implant", arrow: false)
            }
=======
    @StateObject private var model = CameraFrameViewModel()
    
    var body: some View {
        ZStack {
            FrameView(image: model.frame)
                .edgesIgnoringSafeArea(.all)
            
            ErrorView(error: model.error)
>>>>>>> main
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
