//
//  AsyncImageExtension.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/3/21.
//

import Foundation
import SwiftUI
import Combine


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    private var cancellable: AnyCancellable?
    
    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}


struct AsyncImage: View {
    @available(iOS, obsoleted: 15.0, renamed: "SwiftUI.AsyncImage")
    
    @StateObject private var loader: ImageLoader
    @State var image: Image?
//    private let placeholder: Placeholder
    
    init(url: URL) {
//        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        
    }
    
    
    var body: some View {
        content
            .onAppear {
                loader.load()
                self.image = Image(uiImage:loader.image!)
            }//(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image!
                    .resizable()
            } else {
                ProgressView("Loading...").frame(maxWidth: .infinity)
            }
        }
    }
    
    
    
    
}
