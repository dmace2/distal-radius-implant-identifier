//
//  FullScreenImage.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/1/21.
//

import SwiftUI

import SwiftUI
import PDFKit

struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
    }
}



struct FullScreenImageView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: Image?
    var url: URL?
    
    init(url: URL) {
        self.url = url
    }
    
    init(image: Image) {
        self.image = image
    }
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                if let image = image {
    
                    image.resizable().aspectRatio(1, contentMode: .fit)
                        .pinchToZoom()
                }
                    
                if let url = url {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(1, contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .pinchToZoom()
                }
                
            }
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct FullScreenImage_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenImage()
//    }
//}
