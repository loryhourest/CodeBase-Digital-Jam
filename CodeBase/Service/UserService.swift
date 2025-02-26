//
//  UserService.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshots = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshots.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User] {
        let query = FirestoreConstants.UserCollection
        if let limit { query.limit(to: limit) }
        let snapshots = try await query.getDocuments()
        return snapshots.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func fecthUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
