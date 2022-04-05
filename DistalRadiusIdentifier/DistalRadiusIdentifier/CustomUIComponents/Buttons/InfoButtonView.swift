//
//  MenuButtonView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 11/20/21.
//

import SwiftUI

struct InfoButtonView: View {
    @State var showTutorial = false
    @State var showFAQ = false
    
    
    
    var body: some View {
        ZStack {
            NavigationLink(destination:TutorialPageContainerView()
                                .navigationBarTitleDisplayMode(.inline),
                           isActive: $showTutorial) {EmptyView()}
            NavigationLink(destination: FAQView(), isActive: $showFAQ) {EmptyView()}
            Menu {
                Button(action: {
                    self.showTutorial.toggle()
                    
                }) {
                    Label("Tutorial", systemImage: "list.bullet.rectangle")
                }
                
                Button(action: {self.showFAQ.toggle()}) {
                    Label("FAQ", systemImage: "questionmark.circle")
                }
                
            } label: {
                Image(systemName: "info.circle.fill")
            }
        }
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        InfoButtonView()
    }
}
