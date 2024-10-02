//
//  chatBotApp.swift
//  chatBot
//
//  Created by Manuel Rosero Puente on 9/8/24.
//

import SwiftUI
import SwiftData

@main
struct ChatBotApp: App {
    // Initialize the ModelContainer with both Message and ChatSession models
    var container: ModelContainer = try! ModelContainer(for: Message.self, ChatSession.self)

    var body: some Scene {
        WindowGroup {
            ChatView()
                .modelContainer(container)  // Attach the container to the environment
        }
    }
}
