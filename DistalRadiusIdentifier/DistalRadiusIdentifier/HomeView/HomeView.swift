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
    @EnvironmentObject var classificationModel: ClassificationModel
    @State var isActive = false
    
    var body: some View {
        VStack {
            List {
                ForEach(classificationModel.classifications){ row in
                    NavigationLink(destination: ResultsView(classification: row)) {
                        ClassificationResultsRowView(row)
                    }
                }
                .onDelete(perform: removeRows)
            }
            
            Spacer()
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationLink(destination: TakePhotoView().navigationTitle("Take Implant Photo"), isActive: $isActive) {
                    RoundedButton(color: Color("TechBlue"), labelText: "Classify Implant", buttonFunc: {
                        self.isActive.toggle()
                    })
                        .padding()
                }
                .isDetailLink(false)
            } else {
                NavigationLink(destination: TakePhotoView().navigationTitle("Take Implant Photo"), isActive: $isActive) {
                    RoundedButton(color: Color("TechBlue"), labelText: "Classify Implant", buttonFunc: {
                        self.isActive.toggle()
                    })
                        .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                InfoButtonView()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        classificationModel.classifications.remove(atOffsets: offsets)
    }
    
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
