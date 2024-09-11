//
//  ImagePicker.swift
//  base_project_api_integration
//
//  Created by MacBook PRO on 18/10/23.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var uiImage: UIImage
    @Binding var imageData: Data
    @Binding var sourceType: UIImagePickerController.SourceType
    
    init(uiImage: Binding<UIImage>? = nil, imageData: Binding<Data>, sourceType: Binding<UIImagePickerController.SourceType>){
        if let uiImage = uiImage {
            self._uiImage = uiImage
        }else{
            self._uiImage = .constant(UIImage())
        }
        
        self._imageData = imageData
        self._sourceType = sourceType
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let resizedImage = image.resizedTo1MB() {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let getImageData = image.jpegData(compressionQuality: 1.0) ?? Data()
                self.parent.imageData = getImageData
                self.parent.uiImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}
