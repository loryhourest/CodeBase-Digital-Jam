//
//  ChatView.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//

import SwiftUI
import AVKit
import PhotosUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @Environment(\.dismiss) var dismissModal
    let user: User
    var onBack: () -> Void
    
    @State private var selectedImageUrl: URL? = nil
    @State private var selectedVideoURL: URL? = nil
    
    @State private var isFileImporterPresented = false
    
    init(user: User, onBack: @escaping () -> Void) {
        self.user = user
        self.onBack = onBack
        _viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // Header
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            CircularProfileimageView(user: user, size: .xLarge)
                            
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 18, height: 18)
                                
                                Circle()
                                    .fill(Color(.systemGreen))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Text(user.fullname)
                            .font(.custom("Rubik-Medium", size: 25))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                    }
                    
                    // Messages
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            ChatMessageCell(
                                message: message,
                                chatPartner: user,
                                onImageTap: { url in
                                    selectedImageUrl = url
                                },
                                onVideoTap: { url in
                                    selectedVideoURL = url
                                }
                            )
                        }
                    }
                }
                
                if let previewImage = viewModel.previewImage {
                    HStack {
                        previewImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button {
                            viewModel.clearSelectedImage()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.videoData != nil {
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                            Image(systemName: "video.fill")
                                .foregroundColor(.white)
                        }
                        
                        Button("Send") {
                            viewModel.sendCurrentMessage()
                        }
                        .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                if !viewModel.fileName.isEmpty {
                    HStack {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        Text(viewModel.fileName)
                            .font(.custom("Rubik-Medium", size: 14))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                        Button {
                            viewModel.clearSelectedFile()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }

                
                // Message entry area
                HStack(spacing: 10) {
                    PhotosPicker(selection: $viewModel.selectedImage, matching: .images) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }
                    
                    PhotosPicker(selection: $viewModel.selectedVideo, matching: .videos) {
                        Image(systemName: "video")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }
                    
                    Button {
                        isFileImporterPresented = true
                    } label: {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }

                    
                    TextField("Enter a message...", text: $viewModel.messageText, axis: .vertical)
                        .font(.custom("Rubik-Light", size: 17))
                        .foregroundColor(Color(hex: "#9A9A9A"))
                        .padding()
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(30)
                    
                    Button {
                        viewModel.sendCurrentMessage()
                    } label: {
                        Text("Send")
                            .font(.custom("Rubik-Regular", size: 17))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
            }
            .navigationTitle(user.fullname)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onBack()
                        dismissModal()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .appBackground()
            .onAppear {
                tabBarManager.isTabBarHidden = true
            }
            .onDisappear {
                tabBarManager.isTabBarHidden = false
            }
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.data],
            allowsMultipleSelection: false
        ) { result in
            do {
                let selectedFiles = try result.get()
                if let fileURL = selectedFiles.first {
                    viewModel.selectedFile = fileURL
                    viewModel.fileName = fileURL.lastPathComponent
                    viewModel.fileData = try Data(contentsOf: fileURL)
                }
            } catch {
                print("File selection error: \(error)")
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: Binding(
            get: { selectedImageUrl != nil },
            set: { if !$0 { selectedImageUrl = nil } }
        )) {
            if let url = selectedImageUrl {
                FullScreenImageView(url: url) {
                    selectedImageUrl = nil
                }
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { selectedVideoURL != nil },
            set: { if !$0 { selectedVideoURL = nil } }
        )) {
            if let videoURL = selectedVideoURL {
                FullScreenVideoView(videoURL: videoURL) {
                    selectedVideoURL = nil
                }
            }
        }
    }
}



