//
//  ProfileView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    let user: User
    @State private var showSimpleProfileView = false
    @Environment(\.dismiss) var dismissProfileView
    @EnvironmentObject var tabBarManager: TabBarManager

    init(user: User) {
        self.user = user
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            // Header
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        CircularProfileimageView(user: user, size: .xLarge)
                    }
                }
                
                Text(user.fullname)
                    .font(.custom("Rubik-Medium", size: 25))
                    .foregroundColor(Color(hex: "#BBBBBB"))
            }
            
            // List settings
            List {
                Section {
                    ForEach(SettingsOptionsViewModel.allCases) { option in
                        if option == .account {
                            Button {
                                showSimpleProfileView = true
                            } label: {
                                HStack {
                                    Image(option.imageName)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text(option.title)
                                        .font(.custom("Rubik-Medium", size: 15))
                                        .foregroundColor(Color(hex: "#BBBBBB"))
                                        .padding()
                                }
                            }
                        } else {
                            HStack {
                                Image(option.imageName)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text(option.title)
                                    .font(.custom("Rubik-Medium", size: 15))
                                    .foregroundColor(Color(hex: "#BBBBBB"))
                                    .padding()
                            }
                        }
                    }
                }
                
                Section {
                    Button("Log Out") {
                        AuthService.shared.signOut()
                    }
                    Button("Delete Account") {
                    }
                }
                .foregroundColor(Color(hex: "#FF7878"))
            }
        }
        .appBackground()
        .onAppear {
            tabBarManager.isTabBarHidden = true
        }
        .onDisappear {
            tabBarManager.isTabBarHidden = false
        }
        .fullScreenCover(isPresented: $showSimpleProfileView) {
            SimpleProfileView(user: user, onBack: {
                showSimpleProfileView = false
                DispatchQueue.main.async {
                    dismissProfileView()
                }
            })
            .environmentObject(TabBarManager())
        }
    }
}


