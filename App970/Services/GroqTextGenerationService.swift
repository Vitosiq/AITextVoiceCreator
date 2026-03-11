import Foundation

/// Free tier at https://console.groq.com
final class GroqTextGenerationService: AITextGenerationServiceProtocol {
    private let apiKey: () -> String
    private let session: URLSession

    init(apiKey: @escaping () -> String = { Config.groqAPIKey }, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func generateText(
        type: CreationType,
        name: String,
        userText: String,
        country: String,
        style: AIStyle,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let key = apiKey()
        guard !key.isEmpty else {
            completion(.failure(NSError(domain: "Groq", code: 0, userInfo: [NSLocalizedDescriptionKey: "Add GroqAPIKey: replace YOUR_GROQ_API_KEY in Config.plist, or add key in Target → Info. Free key: console.groq.com"])))
            return
        }

        let systemPrompt = buildSystemPrompt(type: type, country: country, style: style)
        let userMessage = "Name or topic: \(name). User text or theme: \(userText). Generate only the \(type.rawValue.lowercased()) content, no titles or labels. Use language appropriate for: \(country)."

        let body: [String: Any] = [
            "model": "llama-3.1-8b-instant",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userMessage]
            ],
            "max_tokens": 1024
        ]

        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions"),
              let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Groq", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            let http = response as? HTTPURLResponse
            let data = data ?? Data()

            if let code = http?.statusCode, code < 200 || code >= 300 {
                let message = Self.parseError(data: data) ?? "HTTP \(code)"
                DispatchQueue.main.async { completion(.failure(NSError(domain: "Groq", code: code, userInfo: [NSLocalizedDescriptionKey: message]))) }
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let first = choices.first,
                  let message = first["message"] as? [String: Any] else {
                let msg = Self.parseError(data: data) ?? "Invalid response"
                DispatchQueue.main.async { completion(.failure(NSError(domain: "Groq", code: -1, userInfo: [NSLocalizedDescriptionKey: msg]))) }
                return
            }

            var raw: String?
            if let str = message["content"] as? String { raw = str }
            else if let parts = message["content"] as? [[String: Any]] { raw = parts.compactMap { $0["text"] as? String }.joined() }
            guard let text = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "Groq", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))) }
                return
            }
            DispatchQueue.main.async { completion(.success(text)) }
        }
        task.resume()
    }

    private static func parseError(data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let error = json["error"] as? [String: Any],
              let message = error["message"] as? String else { return nil }
        return message
    }

    private func buildSystemPrompt(type: CreationType, country: String, style: AIStyle) -> String {
        let styleDesc: String
        switch style {
        case .patriotic: styleDesc = "patriotic and national pride"
        case .humorous: styleDesc = "humorous and fun"
        case .sports: styleDesc = "sports and team spirit"
        case .auto: styleDesc = "balanced and engaging"
        }
        let typeDesc: String
        switch type {
        case .screamer: typeDesc = "A short, powerful stadium screamer: rhythmic chants, repeated phrases, high energy. 2-4 lines."
        case .speech: typeDesc = "A short memorable speech or slogan: 1-3 punchy sentences."
        case .slogan: typeDesc = "A champion-style slogan or catchphrase: inspirational or provocative, 1-2 sentences."
        case .song: typeDesc = "A short fan song: 2-4 lines that could be verses or a chorus, singable and catchy."
        }
        return "You are a creative writer for fan content. Generate a \(type.rawValue.lowercased()). Style: \(styleDesc). Output only the raw text in the language appropriate for \(country). \(typeDesc). No quotes or labels, just the content."
    }
}
