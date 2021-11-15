//
//  FrameView.swift
//  DistalRadiusIdentifier
//
//  Created by Blake Sanie on 11/15/21.
//

import SwiftUI

import SwiftUI

struct FrameView: View {
  var image: CGImage?

  private let label = Text("Video feed")

  var body: some View {
    if let image = image {
      GeometryReader { geometry in
        Image(image, scale: 1.0, orientation: .upMirrored, label: label)
          .resizable()
          .scaledToFill()
          .frame(
            width: geometry.size.width,
            height: geometry.size.height,
            alignment: .center)
          .clipped()
      }
    } else {
      EmptyView()
    }
  }
}

//struct CameraView_Previews: PreviewProvider {
//  static var previews: some View {
//    FrameView(image: nil)
//  }
//}
