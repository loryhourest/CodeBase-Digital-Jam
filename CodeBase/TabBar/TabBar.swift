//
//  TabBar.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//

import SwiftUI

enum TabBar: String, CaseIterable {
    case chats, add, search
    
    var title: String {
        switch self {
        case .chats: return "Chats"
        case .add:   return "Add"
        case .search:return "Search"
        }
    }
    
    var iconName: String {
        switch self {
        case .chats: return "bubble.left.and.bubble.right.fill"
        case .add:   return "plus.circle.fill"
        case .search:return "magnifyingglass"
        }
    }
}
