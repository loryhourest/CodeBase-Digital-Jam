//
//  ChatService.swift
//  CodeBase
//
//  Created by Алихан  on 17.02.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ChatService {
    let chatPartner: User
    
    func sendMessage(_ messageText: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId).collection(currentUid)
         
        let recentCurrentUserRef = FirestoreConstants.MessagesCollection.document(currentUid).collection("recent-messages").document(chatPartnerId)
        let recentPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId).collection("recent-messages").document(currentUid)
        
        let messageId = currentUserRef.documentID
        
        let message = Message(
            messageId: messageId,
            fromId: currentUid,
            toId: chatPartnerId,
            messageText: messageText,
            imageUrl: nil,
            videoUrl: nil,
            fileUrl: nil, fileName: nil,
            timestamp: Timestamp()
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
         
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }
    
    func observeMessages(completion: @escaping([Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        let query = FirestoreConstants.MessagesCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
            
            for (index, message) in messages.enumerated() where !message.isFromCurrentUser {
                messages[index].user = chatPartner
            }
            
            completion(messages)
        }
    }
    
    func sendImageMessage(imageData: Data, text: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        let imageId = UUID().uuidString
        let storageRef = Storage.storage().reference().child("chat_images/\(imageId).jpg")
        
        let compressedData: Data
        if let uiImage = UIImage(data: imageData),
           let jpegData = uiImage.jpegData(compressionQuality: 0.7) {
            compressedData = jpegData
        } else {
            compressedData = imageData
        }
        
        storageRef.putData(compressedData, metadata: nil) { metadata, error in
            if let error = error {
                print("Image upload error: \(error)")
                return
            }
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid)
                        .collection(chatPartnerId).document()
                    let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId)
                        .collection(currentUid).document(currentUserRef.documentID)
                    
                    let message = Message(
                        messageId: currentUserRef.documentID,
                        fromId: currentUid,
                        toId: chatPartnerId,
                        messageText: text,
                        imageUrl: downloadURL.absoluteString,
                        videoUrl: nil,
                        fileUrl: nil, fileName: nil,
                        timestamp: Timestamp()
                    )
                    
                    guard let messageData = try? Firestore.Encoder().encode(message) else { return }
                    currentUserRef.setData(messageData)
                    chatPartnerRef.setData(messageData)
                }
            }
        }
    }
    
    func sendVideoMessage(videoData: Data, text: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        let videoId = UUID().uuidString
        let storageRef = Storage.storage().reference().child("chat_videos/\(videoId).mp4")
        
        storageRef.putData(videoData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error when uploading video: \(error)")
                return
            }
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid)
                        .collection(chatPartnerId).document()
                    let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId)
                        .collection(currentUid).document(currentUserRef.documentID)
                    
                    let message = Message(
                        messageId: currentUserRef.documentID,
                        fromId: currentUid,
                        toId: chatPartnerId,
                        messageText: text,
                        imageUrl: nil,
                        videoUrl: downloadURL.absoluteString,
                        fileUrl: nil, fileName: nil,
                        timestamp: Timestamp()
                    )
                    
                    guard let messageData = try? Firestore.Encoder().encode(message) else { return }
                    currentUserRef.setData(messageData)
                    chatPartnerRef.setData(messageData)
                }
            }
        }
    }
    
    func sendFileMessage(fileData: Data, fileName: String, text: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        let fileId = UUID().uuidString
        let storageRef = Storage.storage().reference().child("chat_files/\(fileId)_\(fileName)")
        
        storageRef.putData(fileData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error when uploading a file: \(error)")
                return
            }
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid)
                        .collection(chatPartnerId).document()
                    let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPartnerId)
                        .collection(currentUid).document(currentUserRef.documentID)
                    
                    let message = Message(
                        messageId: currentUserRef.documentID,
                        fromId: currentUid,
                        toId: chatPartnerId,
                        messageText: text,
                        imageUrl: nil,
                        videoUrl: nil,
                        fileUrl: downloadURL.absoluteString,
                        fileName: fileName,
                        timestamp: Timestamp()
                    )
                    
                    guard let messageData = try? Firestore.Encoder().encode(message) else { return }
                    currentUserRef.setData(messageData)
                    chatPartnerRef.setData(messageData)
                }
            }
        }
    }
}


