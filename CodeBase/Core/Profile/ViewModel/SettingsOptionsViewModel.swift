//
//  SettingsOptionsViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
    case account
    case activestatus
    case privacy
    case notifications
    
    var title: String {
        switch self {
        case .account: return "Account"
        case .activestatus: return "Active Status"
        case .privacy: return "Privacy and Security"
        case .notifications: return "Notifications"
        }
    }
    
    var imageName: String {
        switch self {
        case .account: return "account"
        case .activestatus: return "active"
        case .privacy: return "privacy"
        case .notifications: return "notifications"
            
        }
    }
    
    var id: Int { return self.rawValue }
}
