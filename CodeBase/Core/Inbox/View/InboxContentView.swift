//
//  InboxContentView.swift
//  CodeBase
//
//  Created by Алихан  on 22.02.2025.
//

import SwiftUI

struct InboxContentView: View {
    @Binding var selectedUser: User?
    @Binding var showChat: Bool
    @ObservedObject var viewModel: InboxViewModel
    
    var body: some View {
        List {
            ActiveNowView()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .padding(.vertical)
                .padding(.horizontal, 5)
            
            ForEach(viewModel.recentMessages) { message in
                ZStack {
                    NavigationLink(value: message) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    
                    InboxRowView(message: message)
                }
            }
        }
        .listStyle(PlainListStyle())
        .onChange(of: selectedUser) { newValue in
            showChat = newValue != nil
        }
        .navigationDestination(for: Message.self) { message in
            if let user = message.user {
                ChatView(user: user, onBack: {})
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .profile(let user):
                ProfileView(user: user)
            case .chatView(let user):
                ChatView(user: user, onBack: {})
            }
        }
        .navigationDestination(isPresented: $showChat) {
            if let user = selectedUser {
                ChatView(user: user, onBack: {})
            }
        }
    }
}





