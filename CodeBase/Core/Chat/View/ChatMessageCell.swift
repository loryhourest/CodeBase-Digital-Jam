//
//  ChatMessageCell.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    let chatPartner: User
    var onImageTap: ((URL) -> Void)?
    var onVideoTap: ((URL) -> Void)?
    var onFileTap: ((URL) -> Void)?

    private var isFromCurrentUser: Bool {
        message.isFromCurrentUser
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                messageContent
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 10) {
                    CircularProfileimageView(user: chatPartner, size: .small)
                    messageContent
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    var messageContent: some View {
        VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 8) {
            if let fileUrlStr = message.fileUrl, !fileUrlStr.isEmpty {
                let fixedUrlStr = fileUrlStr.replacingOccurrences(of: " ", with: "%20")
                if let fileUrl = URL(string: fixedUrlStr) {
                    let displayName: String = {
                        if let name = message.fileName, !name.isEmpty {
                            return name
                        }
                        return fileUrl.lastPathComponent
                    }()
                    
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        Text(displayName)
                            .font(.custom("Rubik-Regular", size: 15))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                    }
                    .padding()
                    .background(Color(hex: "#2A2A2A"))
                    .cornerRadius(15)
                    .onTapGesture {
                        onFileTap?(fileUrl)
                    }
                } else {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        Text(message.fileName ?? "File")
                            .font(.custom("Rubik-Regular", size: 15))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                    }
                    .padding()
                    .background(Color(hex: "#2A2A2A"))
                    .cornerRadius(15)
                }
            } else if let videoUrlStr = message.videoUrl, let videoUrl = URL(string: videoUrlStr) {
                ZStack {
                    Color.black
                        .frame(width: 260, height: 200)
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    onVideoTap?(videoUrl)
                }
            } else if let imageUrl = message.imageUrl, let url = URL(string: imageUrl) {
                CachedAsyncImage(url: url)
                    .frame(width: 260, height: 200)
                    .cornerRadius(15)
                    .onTapGesture {
                        onImageTap?(url)
                    }
            } else {
                Text(message.messageText)
                    .font(.custom("Rubik-Regular", size: 17))
                    .padding()
                    .foregroundColor(Color(hex: "#9A9A9A"))
                    .background(Color(hex: "#2A2A2A"))
                    .cornerRadius(15)
            }
        }
        .padding(2)
        .background(Color(hex: "#2A2A2A"))
        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
    }
}











