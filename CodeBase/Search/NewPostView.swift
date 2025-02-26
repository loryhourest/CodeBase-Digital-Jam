//
//  NewPostView.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import SwiftUI
import PhotosUI

struct NewPostView: View {
    @StateObject var viewModel = CreatePostViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: TabBar = .add
    
    let priceRanges = ["0-100", "100-500", "500-1000", "1000-2000", "2000-5000"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Project Description
                        TextField("Write about your project", text: $viewModel.description, axis: .vertical)
                            .font(.custom("Rubik-Light", size: 15))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                            .padding()
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(15)
                        
                        // Role Filter
                        VStack(alignment: .leading, spacing: 8) {
                            Text("We need people:")
                                .font(.custom("Rubik-Medium", size: 16))
                                .foregroundColor(Color(hex: "#BBBBBB"))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.selectedRoles, id: \.self) { role in
                                        HStack(spacing: 4) {
                                            Text(role)
                                                .lineLimit(1)
                                            Button {
                                                if let index = viewModel.selectedRoles.firstIndex(of: role) {
                                                    viewModel.selectedRoles.remove(at: index)
                                                }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#2A2A2A"))
                                        .foregroundColor(Color(hex: "#BBBBBB"))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            
                            TextField("Enter the person's specialty...", text: $viewModel.roleInput)
                                .padding()
                                .background(Color(hex: "#2A2A2A"))
                                .cornerRadius(10)
                                .foregroundColor(Color(hex: "#BBBBBB"))
                            
                            ForEach(viewModel.filteredRoleSuggestions, id: \.self) { suggestion in
                                Button(action: {
                                    if !viewModel.selectedRoles.contains(suggestion) {
                                        viewModel.selectedRoles.append(suggestion)
                                    }
                                    viewModel.roleInput = ""
                                }) {
                                    Text(suggestion)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color(hex: "#BBBBBB"))
                                }
                                .background(Color(hex: "#1E1E1E"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Choosing a price range
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Project Price Range:")
                                .font(.custom("Rubik-Medium", size: 16))
                                .foregroundColor(Color(hex: "#BBBBBB"))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(priceRanges, id: \.self) { range in
                                        Button {
                                            if viewModel.selectedPriceRange == range {
                                                viewModel.selectedPriceRange = nil
                                            } else {
                                                viewModel.selectedPriceRange = range
                                            }
                                        } label: {
                                            Text(range)
                                                .font(.custom("Rubik-Regular", size: 16))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(viewModel.selectedPriceRange == range ? Color.blue : Color(hex: "#2A2A2A"))
                                                .foregroundColor(viewModel.selectedPriceRange == range ? .white : Color(hex: "#BBBBBB"))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Choosing the type of post
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Post Type:")
                                .font(.custom("Rubik-Medium", size: 16))
                                .foregroundColor(Color(hex: "#BBBBBB"))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.postTypes, id: \.self) { type in
                                        Button {
                                            if viewModel.selectedPostType == type {
                                                viewModel.selectedPostType = nil
                                            } else {
                                                viewModel.selectedPostType = type
                                            }
                                        } label: {
                                            Text(type)
                                                .font(.custom("Rubik-Regular", size: 16))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(viewModel.selectedPostType == type ? Color.green : Color(hex: "#2A2A2A"))
                                                .foregroundColor(viewModel.selectedPostType == type ? .white : Color(hex: "#BBBBBB"))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Project photo
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                            if let image = viewModel.projectImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 400, height: 190)
                                    .clipped()
                                    .cornerRadius(15)
                            } else {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(hex: "#2A2A2A"))
                                        .frame(width: 400, height: 190)
                                        .cornerRadius(15)
                                    Text("Choose a photo")
                                        .font(.custom("Rubik-Medium", size: 20))
                                        .foregroundColor(Color(hex: "#BBBBBB"))
                                }
                            }
                        }
                        
                        // The post publishing button
                        HStack {
                            Spacer()
                            Button {
                                Task { await viewModel.createPost() }
                                dismiss()
                            } label: {
                                if viewModel.isUploading {
                                    ProgressView()
                                } else {
                                    Text("Post")
                                        .font(.custom("Rubik-Medium", size: 13))
                                        .frame(width: 65, height: 30)
                                        .background(Color(hex: "#2A2A2A"))
                                        .foregroundColor(Color(hex: "#BBBBBB"))
                                        .cornerRadius(15)
                                }
                            }
                            .disabled(viewModel.isUploading || viewModel.description.isEmpty)
                        }
                        
                    }
                    .padding()
                }
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 5)
            }
            .navigationTitle("New Post")
            .appBackground()
        }
    }
}


