//
//  CustomTabBar.swift
//  CodeBase
//
//  Created by Алихан  on 19.02.2025.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabBar
    
    var body: some View {
        HStack {
            ForEach(TabBar.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 23))
                        Text(tab.title)
                            .font(.custom("Rubik-Medium", size: 11))
                    }
                    .foregroundColor(selectedTab == tab ? Color(hex: "#BBBBBB") : Color(hex: "#6E6E6E"))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(Color(hex: "#2A2A2A"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}
