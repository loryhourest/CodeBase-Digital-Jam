//
//  ContentView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var selectedTab: TabBar = .chats

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView(selectedTab: $selectedTab)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
