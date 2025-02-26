//
//  SimpleProfileView.swift
//  CodeBase
//
//  Created by Алихан  on 21.02.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SimpleProfileView: View {
    @StateObject private var viewModel: SimpleProfileViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    var onBack: () -> Void  
    @State private var isChatPresented = false

    init(user: User, onBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: SimpleProfileViewModel(user: user))
        self.onBack = onBack
    }
    
    var isCurrentUser: Bool {
        viewModel.user.uid == Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile photo
                if let profileImageUrl = viewModel.user.profileImageUrl,
                   let url = URL(string: profileImageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        case .failure(_):
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
                
                // Name and email
                Text(viewModel.user.fullname)
                    .font(.custom("Rubik-Medium", size: 25))
                    .foregroundColor(Color(hex: "#BBBBBB"))
                Text(viewModel.user.email)
                    .font(.custom("Rubik-Light", size: 15))
                    .foregroundColor(Color(hex: "#6E6E6E"))
                
                if !isCurrentUser {
                    Button {
                        isChatPresented = true
                    } label: {
                        Text("Message")
                            .font(.custom("Rubik-Medium", size: 18))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(15)
                    }
                }
                
                if isCurrentUser {
                    TextField("Write your bio", text: $viewModel.bio, axis: .vertical)
                        .font(.custom("Rubik-Light", size: 15))
                        .foregroundColor(Color(hex: "#BBBBBB"))
                        .padding()
                        .background(Color(hex: "#2A2A2A"))
                        .cornerRadius(15)
                    
                    Button(action: {
                        viewModel.updateBio()
                    }) {
                        if viewModel.isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Save")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(viewModel.isSaving)
                } else {
                    ScrollView {
                        Text(viewModel.bio)
                            .font(.custom("Rubik-Light", size: 15))
                            .foregroundColor(Color(hex: "#BBBBBB"))
                            .padding()
                            .background(Color(hex: "#2A2A2A"))
                            .cornerRadius(15)
                    }
                }
                
                if let error = viewModel.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .appBackground()
            .task {
                await viewModel.fetchUserById()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            tabBarManager.isTabBarHidden = true
        }
        .onDisappear {
            tabBarManager.isTabBarHidden = false
        }
        .fullScreenCover(isPresented: $isChatPresented) {
            ChatView(user: viewModel.user, onBack: {
                isChatPresented = false
                onBack()
            })
            .environmentObject(tabBarManager)
        }
    }
}

