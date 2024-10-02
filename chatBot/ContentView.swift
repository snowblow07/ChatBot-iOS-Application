import SwiftUI
import SwiftData

struct ChatView: View {
    @State private var userInput: String = ""
    @State private var isTyping: Bool = false
    @State private var isInputDisabled: Bool = false  // Disable input while waiting for response

    // Fetching persisted chat history and session
    @Query private var messages: [Message]
    @Query private var chatSessions: [ChatSession]

    @Environment(\.modelContext) private var context  // Environment for data context

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color(hex: "#E0E0E0"))  // User message bubble color
                                        .foregroundColor(Color(hex: "#19082b"))  // User message text color
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color(hex: "#3d3446"))  // Bot message bubble color
                                        .foregroundColor(.white)  // Bot message text color
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .id(message.id)  // Assign unique id for each message for scrolling
                        }
                        if isTyping {
                            HStack {
                                Text("Mr. Rosero is typing...")
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .id("TypingIndicator")  // Assign an id to the typing indicator
                        }
                    }
                }
                .background(Color(hex: "#767179"))  // Chat background color
                .onAppear {
                    // Scroll to the bottom when the view appears
                    if let lastMessageId = messages.last?.id {
                        scrollView.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
                .onChange(of: messages.count) {
                    // Scroll to the bottom when a new message is added
                    if let lastMessageId = messages.last?.id {
                        scrollView.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
                .onChange(of: isTyping) { oldvalue, typing in
                    // Scroll to the bottom when typing starts
                    if typing {
                        scrollView.scrollTo("TypingIndicator", anchor: .bottom)
                    }
                }
            }

            HStack {
                TextField("Type a message...", text: $userInput)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(minHeight: 40)
                    .disabled(isInputDisabled)  // Disable text input
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.circle")
                        .padding()
                        .background(isInputDisabled ? Color.gray : Color.blue)  // Disable button when waiting for response
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isInputDisabled)  // Disable button action
            }
            .padding()
        }
        .onAppear(perform: setupSession)
    }
    
    func setupSession() {
        if chatSessions.isEmpty {
            let newSessionId = createSessionId()
            let session = ChatSession(sessionId: newSessionId)
            context.insert(session)
            try? context.save()  // Save session ID persistently
        }
    }
    
    func createSessionId() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyy"
        let datePart = formatter.string(from: Date())
        let randomNum = Int.random(in: 100...999)
        return "\(datePart)\(randomNum)"
    }
    
    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: userInput, isUser: true)
        context.insert(userMessage)
        try? context.save()  // Save user message persistently
        
        userInput = ""  // Clear the text input field
        
        // Disable user input and button
        isInputDisabled = true
        
        // Indicate that the bot is typing
        isTyping = true
        
        // Send the message to the backend
        sendChatMessage(message: userMessage.content)
    }
    
    func sendChatMessage(message: String) {
        let url = URL(string: "https://your-api-endpoint.com/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let sessionId = chatSessions.first?.sessionId else { return }
        
        let parameters: [String: Any] = [
            "message": message,
            "config": sessionId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isTyping = false
                isInputDisabled = false  // Re-enable input when the response is received
                
                guard let data = data, error == nil else {
                    print("Error fetching chatbot response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let responseText = jsonResponse["answer"] as? String {
                        let botMessage = Message(content: responseText, isUser: false)
                        context.insert(botMessage)
                        try? context.save()  // Save bot message persistently
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
}

// Helper to convert hex color string to Color in SwiftUI
extension Color {
    init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
