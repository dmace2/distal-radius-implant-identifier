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
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
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
}

func errorWrapper(error: Error, showingError: Binding<Bool>, retryFunction: @escaping () -> Void) -> AnyView {
    if #available(iOS 15.0, *) {
        return AnyView(ErrorView(error: "Classification Failed")
            .unredacted()
            .alert("Error: \(error.localizedDescription)", isPresented: showingError, actions: {
                Button("Cancel", role: .cancel) { NavigationUtil.popToRootView() }
                Button("Retry", action: retryFunction)
            }, message: {
                Text("Try again or cancel this attempt?")
            }))
        
    } else {
        // Fallback on earlier versions
        return AnyView(ErrorView(error: "Classification Failed")
            .unredacted()
            .alert(isPresented: showingError, content: {
                Alert(
                    title: Text("Error: \(error.localizedDescription)"),
                    message: Text("Try again or cancel this attempt?"),
                    primaryButton: .cancel(Text("Cancel"), action: {
                        NavigationUtil.popToRootView()
                    }),
                    secondaryButton: .default(Text("Retry"), action: retryFunction)
                )
        }))
    }
}
        





struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "This is a test")
    }
}
