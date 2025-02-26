//
//  CachedAsyncImage.swift
//  CodeBase
//
//  Created by Алихан  on 25.02.2025.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        let key = url.absoluteString
        
        if let cachedImage = ImageCache.shared.image(forKey: key) {
            self.image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.insertImage(uiImage, forKey: key)
                self.image = uiImage
            }
        } catch {
            print("Image upload error: \(error)")
        }
    }
}

