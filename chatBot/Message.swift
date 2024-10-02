//
//  Message.swift
//  chatBot
//
//  Created by Manuel Rosero Puente on 9/9/24.
//

import Foundation
import SwiftData

@Model
class Message: Identifiable {
    var id: UUID
    var content: String
    var isUser: Bool
    
    init(content: String, isUser: Bool) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
    }
}
