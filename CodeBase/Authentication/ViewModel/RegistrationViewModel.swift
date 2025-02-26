//
//  RegistrationViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var password = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
    }
}
