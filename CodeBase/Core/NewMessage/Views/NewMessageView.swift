//
//  NewMessageView.swift
//  CodeBase
//
//  Created by Алихан  on 15.02.2025.
//

import SwiftUI

struct NewMessageView: View {
    @State private var findsearch = ""
    @StateObject private var viewModel = NewMessageViewModel()
    @Binding var selectedUser: User?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("Find: ", text: $findsearch)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(Color(hex: "#545454"))
                    .cornerRadius(30)
                    .padding(.horizontal)
                
                Text("Contacs")
                    .foregroundColor(Color(hex: "#BBBBBB"))
                    .font(.custom("Rubik-Light", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ForEach(viewModel.users) { user in
                    VStack {
                        HStack {
                            CircularProfileimageView(user: user, size: .small)
                            
                            Text(user.fullname)
                                .font(.custom("Rubik-SemiBold", size: 15))
                                .foregroundColor(Color(hex: "#BBBBBB"))
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading, 40)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .appBackground()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "#BBBBBB"))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NewMessageView(selectedUser: .constant(User.MOCK_USER))
    }
}
