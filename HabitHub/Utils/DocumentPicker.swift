//
//  DocumentPicker.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import UniformTypeIdentifiers
import ObjectiveC

final class DocumentPicker: NSObject, UIDocumentPickerDelegate {
    private var completion: ((URL) -> Void)?
    
    static func presentJSON(completion: @escaping (URL) -> Void) {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        let delegate = DocumentPicker()
        delegate.completion = completion
        picker.delegate = delegate
        picker.allowsMultipleSelection = false
        picker.modalPresentationStyle = .formSheet
        
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else { return }
        
        root.present(picker, animated: true)
        // Retain delegate during presentation
        objc_setAssociatedObject(picker, Unmanaged.passUnretained(self as AnyObject).toOpaque(), delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { 
            print("DocumentPicker: No URL selected")
            return 
        }
        completion?(url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("DocumentPicker: User cancelled document selection")
    }
}


