//
//  SystemImagePicker.swift
//  PhotoSelectAndCrop
//
//  Created by Dave Kondris on 03/01/21.
//

import SwiftUI

///A struct Code from Hacking With Swift:
///
///Code from [Hacking With Swift]( https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller)
/// - Note: This picker also seems to results in memory leaks when it appears or disappears.

public struct SystemImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var croppedImage: UIImage?
    
    
    var sourceType: UIImagePickerController.SourceType = .camera
    var picker = UIImagePickerController()
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: SystemImagePicker
        
        init(_ parent: SystemImagePicker) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.image = uiImage
                parent.croppedImage = nil
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SystemImagePicker>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<SystemImagePicker>) {

    }
}

extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixCannotMoveEditingBox()
    }
    
    func fixCannotMoveEditingBox() {
            if let cropView = cropView,
               let scrollView = scrollView,
               scrollView.contentOffset.y == 0 {
                
                var top: CGFloat = 0.0
                if #available(iOS 11.0, *) {
                    top = cropView.frame.minY + self.view.safeAreaInsets.top
                } else {
                    // Fallback on earlier versions
                    top = cropView.frame.minY
                }
                let bottom = scrollView.frame.height - cropView.frame.height - top
                scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
                
                var offset: CGFloat = 0
                if scrollView.contentSize.height > scrollView.contentSize.width {
                    offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
                }
                scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.fixCannotMoveEditingBox()
            }
        }
        
        var cropView: UIView? {
            return findCropView(from: self.view)
        }
        
        var scrollView: UIScrollView? {
            return findScrollView(from: self.view)
        }
        
        func findCropView(from view: UIView) -> UIView? {
            let width = UIScreen.main.bounds.width
            let size = view.bounds.size
            if width == size.height, width == size.height {
                return view
            }
            for view in view.subviews {
                if let cropView = findCropView(from: view) {
                    return cropView
                }
            }
            return nil
        }
        
        func findScrollView(from view: UIView) -> UIScrollView? {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            for view in view.subviews {
                if let scrollView = findScrollView(from: view) {
                    return scrollView
                }
            }
            return nil
        }
}
