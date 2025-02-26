//
//  ChatViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 17.02.2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    @Published var previewImage: Image?
    @Published var imageData: Data?
    
    @Published var selectedVideo: PhotosPickerItem? {
        didSet { Task { try await loadVideo() } }
    }
    @Published var videoData: Data?
    
    @Published var selectedFile: URL?
    @Published var fileData: Data?
    @Published var fileName: String = ""
    
    let service: ChatService
    
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        observeMessages()
    }
    
    func observeMessages() {
        service.observeMessages() { messages in
            self.messages.append(contentsOf: messages)
        }
    }
    
    func loadImage() async throws {
        guard let item = selectedImage else { return }
        guard let data = try await item.loadTransferable(type: Data.self) else { return }
        self.imageData = data
        guard let uiImage = UIImage(data: data) else { return }
        await MainActor.run {
            self.previewImage = Image(uiImage: uiImage)
        }
    }
    
    func loadVideo() async throws {
        guard let item = selectedVideo else { return }
        guard let data = try await item.loadTransferable(type: Data.self) else { return }
        self.videoData = data
    }
    
    func sendCurrentMessage() {
        if let fileData = fileData {
            service.sendFileMessage(fileData: fileData, fileName: fileName, text: messageText)
            clearSelectedFile()
        } else if let videoData = videoData {
            service.sendVideoMessage(videoData: videoData, text: messageText)
            clearSelectedVideo()
        } else if let imageData = imageData {
            service.sendImageMessage(imageData: imageData, text: messageText)
            clearSelectedImage()
        } else {
            sendMessage()
        }
        messageText = ""
    }
    
    func sendMessage() {
        service.sendMessage(messageText)
    }
    
    func clearSelectedImage() {
        self.selectedImage = nil
        self.previewImage = nil
        self.imageData = nil
    }
    
    func clearSelectedVideo() {
        self.selectedVideo = nil
        self.videoData = nil
    }
    
    func clearSelectedFile() {
        self.selectedFile = nil
        self.fileData = nil
        self.fileName = ""
    }
}

