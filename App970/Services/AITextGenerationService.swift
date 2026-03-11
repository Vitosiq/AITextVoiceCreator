import Foundation

protocol AITextGenerationServiceProtocol: AnyObject {
    func generateText(
        type: CreationType,
        name: String,
        userText: String,
        country: String,
        style: AIStyle,
        completion: @escaping (Result<String, Error>) -> Void
    )
}
