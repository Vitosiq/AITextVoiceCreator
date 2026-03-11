import Foundation

protocol TranslationServiceProtocol: AnyObject {
    func translate(text: String, toLanguage country: String, completion: @escaping (Result<String, Error>) -> Void)
}

/// Uses Groq to translate text to the language of the chosen country.
final class GroqTranslationService: TranslationServiceProtocol {
    static let shared = GroqTranslationService()
    private let apiKey: () -> String
    private let session: URLSession

    init(apiKey: @escaping () -> String = { Config.groqAPIKey }, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func translate(text: String, toLanguage country: String, completion: @escaping (Result<String, Error>) -> Void) {
        let key = apiKey()
        guard !key.isEmpty else {
            completion(.failure(NSError(domain: "Groq", code: 0, userInfo: [NSLocalizedDescriptionKey: "Groq API key not set."])))
            return
        }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion(.failure(NSError(domain: "Translation", code: -1, userInfo: [NSLocalizedDescriptionKey: "No text to translate."])))
            return
        }

        let languageName = languageName(for: country)
        let systemPrompt = "You are a translator. Translate the user's text into the language appropriate for: \(country) (\(languageName)). Output only the translation, no explanations or quotes."
        let userMessage = trimmed

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
                let msg = Self.parseError(data: data) ?? "HTTP \(code)"
                DispatchQueue.main.async { completion(.failure(NSError(domain: "Groq", code: code, userInfo: [NSLocalizedDescriptionKey: msg]))) }
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let first = choices.first,
                  let message = first["message"] as? [String: Any] else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "Groq", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))) }
                return
            }
            var raw: String?
            if let str = message["content"] as? String { raw = str }
            else if let parts = message["content"] as? [[String: Any]] { raw = parts.compactMap { $0["text"] as? String }.joined() }
            let result = raw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            DispatchQueue.main.async { completion(.success(result)) }
        }
        task.resume()
    }

    private static func parseError(data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let error = json["error"] as? [String: Any],
              let message = error["message"] as? String else { return nil }
        return message
    }

    private func languageName(for country: String) -> String {
        switch country.lowercased() {
        case "usa", "uk": return "English"
        case "germany": return "German"
        case "france": return "French"
        case "spain": return "Spanish"
        case "italy": return "Italian"
        default: return "English"
        }
    }
}
