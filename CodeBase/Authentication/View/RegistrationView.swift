//
//  RegistrationView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "#1E1E1E")
                .ignoresSafeArea()
            
            VStack {
                
                // logo
                
                Image("Codebaseicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 585, height: 153)
                    .padding()
                
                // email field
                
                VStack(spacing: 20) {
                    TextField("Enter your username", text: $viewModel.fullname)
                        .foregroundColor(Color(hex: "#9A9A9A"))
                        .font(.custom("Rubik-Light", size: 14))
                        .padding()
                        .frame(width: 370, height: 53)
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(30)
                        .padding(.horizontal, 30)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .foregroundColor(Color(hex: "#9A9A9A"))
                        .font(.custom("Rubik-Light", size: 14))
                        .padding()
                        .frame(width: 370, height: 53)
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(30)
                        .padding(.horizontal, 30)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .foregroundColor(Color(hex: "#9A9A9A"))
                        .font(.custom("Rubik-Light", size: 14))
                        .padding()
                        .frame(width: 370, height: 53)
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(30)
                        .padding(.horizontal, 30)
                }
                
                // sign up button
                
                Button {
                    Task { try await viewModel.createUser() }
                } label: {
                    Text("Sign Up")
                        .font(.custom("Rubik-SemiBold", size: 17))
                        .foregroundColor(Color(hex: "#9A9A9A"))
                        .frame(width: 200, height: 53)
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(30)
                } .padding(.vertical)
                
                // log in button
                
                
                
                Button {
                    dismiss()
                } label: {
                    VStack {
                        Text("Already have an account?")
                            .font(.custom("Rubik-Light", size: 14))
                            .padding(.top, 20)
                        
                        Text("Log in")
                            .font(.custom("Rubik-SemiBold", size: 17))
                            .padding(.top, 10)
                    }
                } .foregroundColor(Color(hex: "#9A9A9A"))
                
            }
            
        }
    }
}

#Preview {
    RegistrationView()
}
