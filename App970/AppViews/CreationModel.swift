import Foundation
import SwiftUI

enum CreationType: String, Codable, CaseIterable {
    case screamer = "Screamer"
    case speech = "Speech"
    case slogan = "Slogan"
    case song = "Song"
}

enum AIStyle: String, Codable, CaseIterable {
    case patriotic = "1. Patriotic"
    case humorous = "2. Humorous"
    case sports = "3. Sports"
    case auto = "4. Auto"
}

struct Creation: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var type: CreationType
    var name: String
    var text: String
    var additionalText: String?
    var verses: [String]?
    var date: Date
    var country: String
    var aiStyle: AIStyle
    var audioURL: String?
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    var shortDescription: String {
        switch type {
        case .screamer:
            return ""
        case .speech:
            return ""
        case .slogan:
            return ""
        case .song:
            return ""
        }
    }
}

class CreationsManager: ObservableObject {
    @Published var creations: [Creation] = []
    
    private let savePath = FileManager.documentDirectory
        .appendingPathComponent("creations.json")

    init() {
        loadCreations()
    }

    func addCreation(_ creation: Creation) {
        creations.insert(creation, at: 0)
        saveCreations()
    }

    func deleteCreation(at offsets: IndexSet) {
        creations.remove(atOffsets: offsets)
        saveCreations()
    }

    func deleteCreation(_ creation: Creation) {
        if let index = creations.firstIndex(where: { $0.id == creation.id }) {
            creations.remove(at: index)
            saveCreations()
        }
    }
    
    func deleteAll() {
        creations.removeAll()
        
        do {
            if FileManager.default.fileExists(atPath: savePath.path) {
                try FileManager.default.removeItem(at: savePath)
            }
        } catch {
            print("Failed to delete creations file: \(error)")
        }
    }

    private func saveCreations() {
        do {
            let data = try JSONEncoder().encode(creations)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save creations: \(error.localizedDescription)")
        }
    }

    private func loadCreations() {
        do {
            let data = try Data(contentsOf: savePath)
            creations = try JSONDecoder().decode([Creation].self, from: data)
        } catch {
            creations = []
        }
    }
}

extension FileManager {
    static var documentDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


