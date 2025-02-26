//
//  InboxRowView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct InboxRowView: View {
    let message: Message
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 10) {
            CircularProfileimageView(user: message.user, size: .medium)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(message.user?.fullname ?? "")
                    .font(.custom("Rubik-Regular", size: 15))
                    .foregroundColor(Color(hex: "#BBBBBB"))
                
                Text(message.imageUrl != nil ? "Image" : message.messageText)
                    .font(.custom("Rubik-Light", size: 13))
                    .foregroundColor(Color(hex: "#BBBBBB"))
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)

            }
            
            HStack {
                Text(message.timestampString)
                
                Image(systemName: "chevron.right")
            }
            .font(.custom("Rubik-Light", size: 13))
            .foregroundColor(Color(hex: "#BBBBBB"))
        }
        .padding(.horizontal, 5)
        .frame(height: 72)
    }
}


