//
//  FullScreenImageView.swift
//  CodeBase
//
//  Created by Алихан  on 25.02.2025.
//

import SwiftUI

struct FullScreenImageView: View {
    let url: URL
    let onDismiss: () -> Void

    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()
            
            CachedAsyncImage(url: url)
                .aspectRatio(contentMode: .fit)
                // Применяем масштабирование
                .scaleEffect(finalScale * currentScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { scale in
                            currentScale = scale
                        }
                        .onEnded { scale in
                            finalScale *= scale
                            currentScale = 1.0
                        }
                )
                .frame(maxWidth: UIScreen.main.bounds.width,
                       maxHeight: UIScreen.main.bounds.height)
                .background(Color.black)
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
            .zIndex(1)
        }
    }
}



