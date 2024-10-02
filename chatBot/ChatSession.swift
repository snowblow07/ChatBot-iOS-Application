//
//  ChatSession.swift
//  chatBot
//
//  Created by Manuel Rosero Puente on 9/9/24.
//

import Foundation
import SwiftData

@Model
class ChatSession {
    // Renamed from `id` to avoid colliding with SwiftData's built-in `id: PersistentIdentifier`.
    // @Model also conforms this class to Identifiable automatically.
    var sessionUUID: UUID
    var sessionId: String
    
    init(sessionId: String) {
        self.sessionUUID = UUID()
        self.sessionId = sessionId
    }
}
