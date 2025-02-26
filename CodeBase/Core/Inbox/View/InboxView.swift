//
//  InboxView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    @State private var selectedTab: TabBar = .chats
    
    private var user: User? {
        viewModel.currentUser
    }
    
    var body: some View {
        
        NavigationStack {
            InboxContentView(selectedUser: $selectedUser, showChat: $showChat, viewModel: viewModel)
                .background(Color.clear)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            if let user = user {
                                NavigationLink(value: Route.profile(user)) {
                                    CircularProfileimageView(user: user, size: .small)
                                }
                            }
                            Text("Chats")
                                .font(.custom("Rubik-SemiBold", size: 20))
                                .foregroundColor(Color(hex: "#9A9A9A"))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showNewMessageView.toggle()
                            selectedUser = nil
                        } label: {
                            Image("addicon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $showNewMessageView) {
            NewMessageView(selectedUser: $selectedUser)
        }
        
    }
}




