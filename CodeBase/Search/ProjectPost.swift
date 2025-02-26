//
//  ProjectPost.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import Foundation
import FirebaseFirestore

struct ProjectPost: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let fullname: String
    let email: String
    let profileImageUrl: String?
    let description: String
    let projectImageUrl: String?
    let roles: [String]?
    let priceRange: String?    
    let postType: String?
    let timestamp: Date?
}


