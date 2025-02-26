//
//  InboxViewModel.swift
//  CodeBase
//
//  Created by Алихан  on 16.02.2025.
//


import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    private var service = InboxService()
    
    init() {
        setupSubscribers()
        service.observeRecentMessages()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        } .store(in: &cancellables)
        
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        } .store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        let newMessages = changes.compactMap { try? $0.document.data(as: Message.self) }
        
        var groupedMessages: [String: Message] = [:]
        for message in newMessages {
            if let existingMessage = groupedMessages[message.chatPartnerId] {
                if message.timestamp.dateValue() > existingMessage.timestamp.dateValue() {
                    groupedMessages[message.chatPartnerId] = message
                }
            } else {
                groupedMessages[message.chatPartnerId] = message
            }
        }
        
        self.recentMessages.removeAll()
        
        for var message in groupedMessages.values {
            UserService.fecthUser(withUid: message.chatPartnerId) { user in
                message.user = user
                self.recentMessages.append(message)
                
                self.recentMessages.sort { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
            }
        }
    }
}
