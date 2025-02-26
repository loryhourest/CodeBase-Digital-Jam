//
//  SimpleProfileViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 21.02.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


class SimpleProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var bio: String
    @Published var isSaving: Bool = false
    @Published var error: String? = nil

    init(user: User) {
        self.user = user
        self.bio = user.bio ?? ""
    }
    
    func fetchUserById() async {
        guard let uid = user.uid else { return }
        do {
            let document = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()
            let updatedUser: User = try document.data(as: User.self)
            DispatchQueue.main.async {
                self.user = updatedUser
                self.bio = updatedUser.bio ?? ""
            }
        } catch {
            print("user upload error: \(error.localizedDescription)")
        }
    }
    
    func updateBio() {
        guard let uid = user.uid else { return }
        isSaving = true
        error = nil
        
        let data: [String: Any] = ["bio": bio]
        Firestore.firestore().collection("users").document(uid).setData(data, merge: true) { [weak self] err in
            DispatchQueue.main.async {
                self?.isSaving = false
                if let err = err {
                    self?.error = err.localizedDescription
                } else {
                    print("Bio updated successfully")
                    Task {
                        await self?.fetchUserById()
                    }
                }
            }
        }
    }
}
