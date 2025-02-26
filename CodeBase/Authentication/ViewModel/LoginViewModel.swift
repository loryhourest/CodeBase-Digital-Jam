//
//  LoginViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
