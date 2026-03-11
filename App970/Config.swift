import Foundation

enum Config {
    /// Groq API key. Free at https://console.groq.com
    static var groqAPIKey: String {
        // 1) Target Info / Build Setting (Xcode → Target → Build Settings → INFOPLIST_KEY_GroqAPIKey)
        if let key = Bundle.main.object(forInfoDictionaryKey: "GroqAPIKey") as? String,
           isValidKey(key) { return key }
        // 2) Config.plist in bundle
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["GroqAPIKey"] as? String,
           isValidKey(key) { return key }
        // 3) Info.plist file in bundle
        if let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["GroqAPIKey"] as? String,
           isValidKey(key) { return key }
        // 4) Fallback key (remove in production; use Build Settings or Config.plist instead)
        return fallbackGroqKey
    }

    private static var fallbackGroqKey: String {
        "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"
    }

    private static func isValidKey(_ key: String) -> Bool {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed != "YOUR_GROQ_API_KEY"
    }
}
