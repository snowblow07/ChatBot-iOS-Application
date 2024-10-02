# ChatBot iOS Application

A sleek, modern, and persistent ChatBot application built with **SwiftUI** and **SwiftData**. This project demonstrates a clean implementation of a chat interface with local persistence and asynchronous backend communication.

## 🚀 Features

- **Persistent Chat History:** Utilizes **SwiftData** to store messages and chat sessions locally, ensuring a seamless user experience across app launches.
- **Dynamic UI:** A responsive chat interface with custom bubble styling, support for hex colors, and smooth scrolling.
- **Typing Indicator:** Real-time-like feedback with a "Typing..." indicator while waiting for the bot's response.
- **Asynchronous Networking:** Handles backend communication using `URLSession` and `JSONSerialization` to send and receive chat messages.
- **Session Management:** Automatically generates and persists unique session identifiers for each user.

## 🛠 Tech Stack

- **UI Framework:** SwiftUI
- **Data Persistence:** SwiftData
- **Networking:** URLSession
- **Language:** Swift 5.10+
- **Minimum iOS Version:** iOS 17.0+

## 📂 Project Structure

- `ContentView.swift`: The main UI component containing the chat logic and view.
- `Message.swift`: SwiftData model for individual chat messages.
- `ChatSession.swift`: SwiftData model for managing user sessions.
- `chatBotApp.swift`: The app's entry point, initializing the SwiftData container.

## ⚙️ Configuration

To use this application with your own backend:

1. Open `ContentView.swift`.
2. Locate the `sendChatMessage` function.
3. Update the `url` variable with your backend endpoint:
   ```swift
   let url = URL(string: "https://your-api-endpoint.com/chat")!
   ```
4. Ensure your backend expects a POST request with the following JSON body:
   ```json
   {
     "message": "User's message content",
     "config": "SessionID"
   }
   ```
   And returns a response in the following format:
   ```json
   {
     "answer": "Bot's response content"
   }
   ```

## 📱 Getting Started

1. Clone the repository.
2. Open `chatBot.xcodeproj` in Xcode 15 or later.
3. Select an iPhone simulator (iOS 17+) and run the project (⌘R).

---

*This project is part of my professional portfolio. Feel free to explore the code and reach out with any questions!*
