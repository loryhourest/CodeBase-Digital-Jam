//
//  PostsViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [ProjectPost] = []
    
    private var listener: ListenerRegistration?
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        listener = Firestore.firestore().collection("helpPosts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error receiving posts: \(error.localizedDescription)")
                    return
                }
                
                self?.posts = snapshot?.documents.compactMap { document in
                    try? document.data(as: ProjectPost.self)
                } ?? []
            }
    }
    
    deinit {
        listener?.remove()
    }
}
