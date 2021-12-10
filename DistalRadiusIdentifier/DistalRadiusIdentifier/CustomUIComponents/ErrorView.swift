//
//  ErrorView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/3/21.
//

import SwiftUI

struct ErrorView: View {
  var error: String?

  var body: some View {
    VStack {
      Text(error ?? "")
        .bold()
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(8)
        .foregroundColor(.white)
        .background(Color.red.edgesIgnoringSafeArea(.top))
        .opacity(error == nil ? 0.0 : 1.0)
        .animation(.easeInOut, value: 0.25)

      Spacer()
    }
  }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "This is a test")
    }
}
