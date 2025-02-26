//
//  Message.swift
//  CodeBase
//
//  Created by Алихан  on 17.02.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let messageText: String
    let imageUrl: String?
    let videoUrl: String?
    let fileUrl: String?
    let fileName: String?
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageId ?? NSUUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
}
