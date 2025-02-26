//
//  CreatePostViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI

@MainActor
class CreatePostViewModel: ObservableObject {
    @Published var description: String = ""
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    @Published var projectImage: UIImage?
    @Published var isUploading: Bool = false
    @Published var roleInput: String = ""
    @Published var selectedRoles: [String] = []
    
    @Published var selectedPriceRange: String? = nil
    
    @Published var selectedPostType: String? = nil
    
    let postTypes = ["Project", "Help", "Hackathon"]
    
    let roleSuggestions = [
        "iOS Developer",
        "Android Developer",
        "Frontend Developer",
        "Backend Developer",
        "UI/UX Designer",
        "DevOps Engineer",
        "QA Engineer",
        "Data Scientist"
    ]
    
    var filteredRoleSuggestions: [String] {
        if roleInput.isEmpty {
            return []
        } else {
            return roleSuggestions.filter { $0.lowercased().contains(roleInput.lowercased()) }
        }
    }
    
    func loadImage() async {
        guard let item = selectedItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.projectImage = uiImage
            }
        } catch {
            print("Error when uploading an image: \(error)")
        }
    }
    
    func createPost() async {
        guard let currentUser = Auth.auth().currentUser,
              let user = UserService.shared.currentUser else {
            print("The user is not logged in or user data not available")
            return
        }
        
        isUploading = true
        
        var projectImageUrl: String? = nil
        if let image = projectImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            do {
                let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("project_posts/\(imageName).jpg")
                _ = try await storageRef.putDataAsync(imageData, metadata: nil)
                projectImageUrl = try await storageRef.downloadURL().absoluteString
            } catch {
                print("Error when uploading an image in Storage: \(error)")
            }
        }
        
        let postData: [String: Any] = [
            "userId": currentUser.uid,
            "fullname": user.fullname,
            "email": user.email,
            "profileImageUrl": user.profileImageUrl as Any,
            "description": description,
            "projectImageUrl": projectImageUrl as Any,
            "roles": selectedRoles,
            "priceRange": selectedPriceRange as Any,
            "postType": selectedPostType as Any,
            "timestamp": Date()
        ]
        
        do {
            _ = try await Firestore.firestore().collection("helpPosts").addDocument(data: postData)
            print("Post created successfully")
        } catch {
            print("Error creating a post: \(error)")
        }
        
        isUploading = false
    }
}


