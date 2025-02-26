//
//  PostsListView.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import SwiftUI

struct PostsListView: View {
    @StateObject var viewModel = PostsViewModel()
    @State private var selectedTab: TabBar = .search
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var selectedUser: User?
    @State private var filterTag: String = ""     
    @State private var filterPrice: String = ""
    @State private var filterPostType: String = ""
    @Environment(\.dismiss) var dismiss

    let roleSuggestions = [
        "iOS Developer",
        "Android Developer",
        "Frontend Developer",
        "Backend Developer",
        "UI/UX Designer",
        "DevOps Engineer",
        "QA Engineer",
        "Data Scientist"
    ]
    
    let priceRanges = ["0-100", "100-500", "500-1000", "1000-2000", "2000-5000"]
    let postTypes = ["Project", "Help", "Hackathon"]
    
    var filteredPosts: [ProjectPost] {
        viewModel.posts.filter { post in
            let roleMatches: Bool = {
                if filterTag.isEmpty { return true }
                if let roles = post.roles {
                    return roles.contains { $0.lowercased() == filterTag.lowercased() }
                }
                return false
            }()
            
            let priceMatches: Bool = {
                if filterPrice.isEmpty { return true }
                return (post.priceRange ?? "").lowercased() == filterPrice.lowercased()
            }()
            
            let typeMatches: Bool = {
                if filterPostType.isEmpty { return true }
                return (post.postType ?? "").lowercased() == filterPostType.lowercased()
            }()
            
            return roleMatches && priceMatches && typeMatches
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Role Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(roleSuggestions, id: \.self) { role in
                            Button(action: {
                                if filterTag.lowercased() == role.lowercased() {
                                    filterTag = ""
                                } else {
                                    filterTag = role
                                }
                            }) {
                                Text(role)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(filterTag.lowercased() == role.lowercased() ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(filterTag.lowercased() == role.lowercased() ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Фильтр по цене
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(priceRanges, id: \.self) { range in
                            Button(action: {
                                if filterPrice.lowercased() == range.lowercased() {
                                    filterPrice = ""
                                } else {
                                    filterPrice = range
                                }
                            }) {
                                Text(range)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(filterPrice.lowercased() == range.lowercased() ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(filterPrice.lowercased() == range.lowercased() ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Filter by post type
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(postTypes, id: \.self) { type in
                            Button(action: {
                                if filterPostType.lowercased() == type.lowercased() {
                                    filterPostType = ""
                                } else {
                                    filterPostType = type
                                }
                            }) {
                                Text(type)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(filterPostType.lowercased() == type.lowercased() ? Color.orange : Color.gray.opacity(0.3))
                                    .foregroundColor(filterPostType.lowercased() == type.lowercased() ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                List {
                    ForEach(filteredPosts) { post in
                        PostRowView(post: post)
                            .onTapGesture {
                                let user = User(
                                    uid: post.userId,
                                    fullname: post.fullname,
                                    email: post.email,
                                    profileImageUrl: post.profileImageUrl
                                )
                                selectedUser = user
                            }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Posts")
                
                NavigationLink(
                    destination: Group {
                        if let user = selectedUser {
                            SimpleProfileView(user: user, onBack: {
                                selectedUser = nil
                            })
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: Binding(
                        get: { selectedUser != nil },
                        set: { newValue in
                            if !newValue {
                                selectedUser = nil
                            }
                        }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}


