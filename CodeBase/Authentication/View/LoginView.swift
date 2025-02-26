//
//  LoginView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            
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
                        TextField("Enter your email", text: $viewModel.email)
                            .foregroundColor(Color(hex: "#BEBEBE"))
                            .font(.custom("Rubik-Light", size: 14))
                            .padding()
                            .frame(width: 370, height: 53)
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(30)
                            .padding(.horizontal, 30)
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .foregroundColor(Color(hex: "#BEBEBE"))
                            .font(.custom("Rubik-Light", size: 14))
                            .padding()
                            .frame(width: 370, height: 53)
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(30)
                            .padding(.horizontal, 30)
                    }
                    
                    
                    // forgot password button
                    
                    Button {
                        print("forgot password")
                    } label: {
                        Text("Forgot password?")
                            .font(.custom("Rubik-Light", size: 14))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                            .padding(.top, 20)
                            .padding(.trailing, 120)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // login button
                    
                    Button {
                        Task { try await viewModel.login() }
                    } label: {
                        Text("Log In")
                            .font(.custom("Rubik-SemiBold", size: 17))
                            .foregroundColor(Color(hex: "#9A9A9A"))
                            .frame(width: 200, height: 53)
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(30)
                    } .padding(.vertical)
                    
                    // login with google button
                    
                    HStack {
                        Rectangle()
                            .frame(width: 160, height: 1)
                        
                        Text("OR")
                            .font(.custom("Rubik-Medium", size: 17))
                        
                        
                        Rectangle()
                            .frame(width: 160, height: 1)
                    } .foregroundColor(Color(hex: "#A1A1A1"))
                    
                    HStack {
                        Image("Google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                    } .padding(.top, 5)
                    
                    // sign up button
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        VStack {
                            Text("Don't have an account?")
                                .font(.custom("Rubik-Light", size: 14))
                                .padding(.top, 20)
                            
                            Text("Sign Up")
                                .font(.custom("Rubik-SemiBold", size: 17))
                                .padding(.top, 10)
                        }
                    } .foregroundColor(Color(hex: "#9A9A9A"))
                }
            } .background(Color.gray)
        }
    }
}

#Preview {
    LoginView()
}
