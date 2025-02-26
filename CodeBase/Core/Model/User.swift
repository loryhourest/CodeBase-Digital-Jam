//
//  User.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?
    let fullname: String
    let email: String
    var profileImageUrl: String?
    var bio: String?

    var id: String {
        return uid ?? NSUUID().uuidString
    }
    
    var firstName: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullname)
        return components?.givenName ?? fullname
    }
}

extension User {
    static let MOCK_USER = User(fullname: "Alikhan", email: "alikhan.mukayev@gmail.com", profileImageUrl: "logotest", bio: "my bio")
}

