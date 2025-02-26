//
//  MainTabView.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: TabBar
    @StateObject var tabBarManager = TabBarManager()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .chats:
                    NavigationStack {
                        InboxView()
                    }
                case .add:
                    NavigationStack {
                        NewPostView()
                    }
                case .search:
                    NavigationStack {
                        PostsListView()
                    }
                }
            }
            
            
            if !tabBarManager.isTabBarHidden {
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 5)
            }
        }
        .environmentObject(tabBarManager)
    }
}
