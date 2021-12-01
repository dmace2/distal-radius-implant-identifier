//
//  ResultsView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var doneBool = false
    
    var body: some View {
        NavigationLink(destination: HomeView(),  isActive: $doneBool) {
            EmptyView()
        }
                       
                       
                       
                       
                       
        GeometryReader { geo in
            VStack {
                Spacer().frame(height: geo.size.height / 50)
                
                
                Text("Synthes")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 50).weight(.bold))
                    .foregroundColor(Color("TechBlue"))
                
                Text("90.01%")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.system(size: 40))
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                
                
                List {
                    ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
                    ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
                    ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
                    ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
                    ResultsItemView(ResultsItem(companyName: "Synthes", percentage: 95.91))
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            Button {
                NavigationUtil.popToRootView()
//                self.presentationMode.wrappedValue.dismiss()
//                self.presentationMode.wrappedValue.dismiss()
//                self.rootPresentationMode.wrappedValue.dismiss()
//                self.doneBool.toggle()
            } label: {
                Text("Done")
            }
        }
    }
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
