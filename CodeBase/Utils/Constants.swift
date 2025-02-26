//
//  Constants.swift
//  CodeBase
//
//  Created by Алихан  on 17.02.2025.
//

import Foundation
import FirebaseFirestore

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
}
