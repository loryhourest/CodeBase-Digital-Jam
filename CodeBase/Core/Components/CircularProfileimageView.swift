//
//  CircularProfileimageView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

enum ProfileImageSize {
    case XXSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimension: CGFloat {
        switch self {
        case .XXSmall: return 28
        case .xSmall: return 35
        case .small: return 38
        case .medium: return 55
        case .large: return 64
        case .xLarge: return 100
        }
    }
}

struct CircularProfileimageView: View {
    let user: User?
    let size: ProfileImageSize
    var body: some View {
        if let imageUrl = user?.profileImageUrl, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size.dimension, height: size.dimension)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.dimension, height: size.dimension)
                        .clipShape(Circle())
                case .failure(_):
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: size.dimension, height: size.dimension)
                        .foregroundColor(.gray)
                @unknown default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: size.dimension, height: size.dimension)
                        .foregroundColor(.gray)
                }
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CircularProfileimageView(user: User.MOCK_USER, size: .medium)
}

