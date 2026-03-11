import Foundation

protocol CreationGeneratorProtocol: AnyObject {
    func generate(
        type: CreationType,
        name: String,
        text: String,
        country: String,
        style: AIStyle,
        completion: @escaping (Result<Creation, Error>) -> Void
    )
}

final class CreationGenerator: ObservableObject, CreationGeneratorProtocol {
    private let aiService: AITextGenerationServiceProtocol

    init(aiService: AITextGenerationServiceProtocol) {
        self.aiService = aiService
    }

    func generate(
        type: CreationType,
        name: String,
        text: String,
        country: String,
        style: AIStyle,
        completion: @escaping (Result<Creation, Error>) -> Void
    ) {
        aiService.generateText(
            type: type,
            name: name,
            userText: text,
            country: country,
            style: style
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let generatedText):
                let creation = Creation(
                    type: type,
                    name: name,
                    text: generatedText,
                    additionalText: text,
                    verses: nil,
                    date: Date(),
                    country: country,
                    aiStyle: style,
                    audioURL: nil
                )
                completion(.success(creation))
            }
        }
    }
}
