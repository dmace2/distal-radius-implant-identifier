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
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
//                List {}
                Spacer()
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(Color("TechBlue"))
                    .opacity(0.8)
                    .frame(width: geo.size.width / 5)
                    .onTapGesture {
                        self.classify.toggle()
                    }
                Text("Classify Implants \nto See Results")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(Color("TechBlue").opacity(0.8))
                Spacer()
                NavigationLink(destination: TakePhotoView().environmentObject(cameraModel).navigationTitle("Take Implant Photo"), isActive: $classify) {
                    ArrowButton(buttonFunc: {self.classify = true}, labelText: "Classify Implant", arrow: false)
                        .padding()
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
