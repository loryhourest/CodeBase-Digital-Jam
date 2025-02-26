//
//  PostsRowView.swift
//  CodeBase
//
//  Created by Алихан  on 23.02.2025.
//

import SwiftUI

struct PostRowView: View {
    let post: ProjectPost  
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Photo, name and email
            HStack(spacing: 4) {
                Button {
                } label: {
                    if let profileImageUrl = post.profileImageUrl,
                       let url = URL(string: profileImageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView().frame(width: 40, height: 40)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            case .failure(_):
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.fullname)
                        .font(.custom("Rubik-Regular", size: 17))
                        .foregroundColor(Color(hex: "#BBBBBB"))
                    Text(post.email)
                        .font(.custom("Rubik-Light", size: 13))
                        .foregroundColor(Color(hex: "#6E6E6E"))
                }
                Spacer()
            }
            
            // Post description
            Text(post.description)
                .font(.custom("Rubik-Light", size: 15))
                .foregroundColor(Color(hex: "#BBBBBB"))
            
            // Project photo
            if let projectImageUrl = post.projectImageUrl,
               let url = URL(string: projectImageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 190)
                            .clipped()
                            .cornerRadius(15)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            if let roles = post.roles, !roles.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("We need people:")
                        .font(.custom("Rubik-Medium", size: 14))
                        .foregroundColor(Color(hex: "#BBBBBB"))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(roles, id: \.self) { role in
                                Text(role)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "#2A2A2A"))
                                    .foregroundColor(Color(hex: "#BBBBBB"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.top, 4)
            }
            
            if let priceRange = post.priceRange, !priceRange.isEmpty {
                Text("Price Range: \(priceRange) USD")
                    .font(.custom("Rubik-Medium", size: 15))
                    .foregroundColor(Color(hex: "#BBBBBB"))
            }
            
            // Отображение времени
            if let timestamp = post.timestamp {
                Text(timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
