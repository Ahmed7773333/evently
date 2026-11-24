//
//  EventImageView.swift
//  evently
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Displays an event's cover image, prioritizing user-picked image data
/// and falling back cleanly to the bundled asset image.
struct EventImageView: View {
    let imageName: String
    let imageData: Data?

    var body: some View {
        if let imageData, let decodedImage = decodeImage(from: imageData) {
            decodedImage
                .resizable()
                .scaledToFill()
        } else {
            Image(imageName)
                .resizable()
                .scaledToFill()
        }
    }

    private func decodeImage(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        return nil
        #endif
    }
}
