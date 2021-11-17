/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreImage
import SwiftUI

class CameraFrameViewModel: ObservableObject {
    @Published var error: Error?
    @Published var frame: CGImage?
    
    private let context = CIContext()
    
    let cameraManager = CameraManager.shared
    let frameManager = FrameManager.shared
    
    var capturedImage: CGImage?
    
    var imageDimension: CGFloat
    
    init() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            self.imageDimension = UIScreen.main.bounds.width
            break
        case .pad:
            // It's an iPad (or macOS Catalyst)
            self.imageDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2
            break
        @unknown default:
            self.imageDimension = UIScreen.main.bounds.width
            break
        }
        
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        // swiftlint:disable:next array_init
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                guard let image = CGImage.create(from: buffer) else {
                    return nil
                }
                
                var orientationAngle: CGFloat
                switch UIDevice.current.orientation {
                case .portrait:
                    orientationAngle = 0
                    break
                case .portraitUpsideDown:
                    orientationAngle = Double.pi / 2
                    break
                case .landscapeLeft:
                    orientationAngle = Double.pi / 2
                    break
                case .landscapeRight:
                    orientationAngle = -1 * Double.pi / 2
                    break
                @unknown default:
                    orientationAngle = 0
                    break
                }
                
                let transform = CGAffineTransform(rotationAngle: orientationAngle)
                
                
                
                let ciImage = CIImage(cgImage: image).transformed(by: transform)
                return self.context.createCGImage(ciImage, from: ciImage.extent)
            }
            .assign(to: &$frame)
    }
}
