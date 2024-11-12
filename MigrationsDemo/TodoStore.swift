import Foundation
import SwiftUI

@Observable
class TodoStore {
    var todos: [Todo]

    private var fileProvider: any FileProvider

    required init(todos: [Todo], fileProvider: any FileProvider) {
        self.todos = todos
        self.fileProvider = fileProvider
    }

    static func load(using fileProvider: any FileProvider) -> Self {
        let todos: [Todo] = {
            do {
                guard let data = try fileProvider.load(fileProvider.todosFileURL) else {
                    return []
                }
                let decoder = JSONDecoder()
                return try decoder.decode([Todo].self, from: data)
            } catch {
                print("ERROR: \(error)")
                assertionFailure("Needs a migration!")
                return []
            }
        }()

        return Self(todos: todos, fileProvider: fileProvider)
    }

    func save() {
        let fileURL = fileProvider.todosFileURL
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(todos)
            try fileProvider.write(data: data, to: fileURL)

        } catch {
            print("ERROR: \(error)")
        }
    }
}

extension FileProvider {
    var todosFileURL: URL {
        documentsDirectory
            .appending(path: "todos.json", directoryHint: .inferFromPath)
    }
}
