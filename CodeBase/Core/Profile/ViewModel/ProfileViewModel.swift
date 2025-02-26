//
//  ProfileViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    
    private let user: User
    private var listener: ListenerRegistration?
    
    init(user: User) {
        self.user = user
        
        guard let uid = user.uid else {
            fatalError("User uid is nil")
        }
        
        let docRef = Firestore.firestore().collection("users").document(uid)
        listener = docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  let urlString = data["profileImageUrl"] as? String,
                  let url = URL(string: urlString) else {
                print("Data error or invalid URL")
                return
            }
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let uiimage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage = Image(uiImage: uiimage)
                    }
                }
            }.resume()
        }
        
        Task {
            await loadProfileImage()
        }
    }

    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiimage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiimage)
        
        do {
            let downloadURL = try await uploadProfileImage(data: imageData)
            try await updateUserProfileImageURL(url: downloadURL)
        } catch {
            print("Error when uploading a photo: \(error)")
        }
    }
    
    func loadProfileImage() async {
        guard let uid = user.uid else {
            print("UID absent")
            return
        }
        
        let userDoc = Firestore.firestore().collection("users").document(uid)
        
        do {
            let document = try await userDoc.getDocument()
            if let data = document.data(),
               let urlString = data["profileImageUrl"] as? String,
               let url = URL(string: urlString) {
                
                if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
                    DispatchQueue.main.async {
                        self.profileImage = Image(uiImage: cachedImage)
                    }
                } else {
                    var request = URLRequest(url: url)
                    request.cachePolicy = .reloadIgnoringLocalCacheData
                    let (imageData, _) = try await URLSession.shared.data(for: request)
                    if let uiimage = UIImage(data: imageData) {
                        ImageCache.shared.insertImage(uiimage, forKey: url.absoluteString)
                        DispatchQueue.main.async {
                            self.profileImage = Image(uiImage: uiimage)
                        }
                    }
                }
            } else {
                print("There is no data or the url is invalid")
            }
        } catch {
            print("Error when uploading profile photo: \(error)")
        }
    }


    
    func uploadProfileImage(data: Data) async throws -> URL {
        guard let uid = user.uid else {
            throw NSError(domain: "UserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID absent"])
        }
        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
        _ = try await storageRef.putDataAsync(data, metadata: nil)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL
    }
    
    func updateUserProfileImageURL(url: URL) async throws {
        guard let uid = user.uid else {
            throw NSError(domain: "UserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID absent"])
        }
        
        let timestamp = Date().timeIntervalSince1970
        var urlString = url.absoluteString
        if urlString.contains("?") {
            urlString += "&v=\(timestamp)"
        } else {
            urlString += "?v=\(timestamp)"
        }
        
        let userDoc = Firestore.firestore().collection("users").document(uid)
        try await userDoc.updateData(["profileImageUrl": urlString])
    }
}

