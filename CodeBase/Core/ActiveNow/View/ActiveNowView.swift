//
//  ActiveNowView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(value: Route.chatView(user)) {
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                CircularProfileimageView(user: user, size: .medium)
                                
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(Color(.systemGreen))
                                        .frame(width: 12, height: 12)
                                }
                            }
                            
                            Text(user.firstName)
                                .font(.custom("Rubik-Regular", size: 14))
                                .foregroundColor(Color(hex: "#BBBBBB"))
                                .padding(.top, 5)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
    }
}

#Preview {
    ActiveNowView()
}
