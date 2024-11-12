import Monarch
import Foundation

enum Migrations {
    enum v1 {
        struct Todo: Codable {
            let id: UUID
            let name: String
            let isComplete: Bool
        }

        struct MigrateTodo_IncludeDateCompleted: Migration {
            static var id: MigrationID = "migrate_todo_date_completed"

            @MigrationDependency
            var fileProvider: any FileProvider

            func run() async throws {
                let fileURL = fileProvider.todosFileURL

                guard let data = try fileProvider.load(fileURL) else {
                    return
                }
                
                let decoder = JSONDecoder()
                let v1Todos = try decoder.decode([Migrations.v1.Todo].self, from: data)

                let v2Todos = v1Todos.map { todo in
                    MigrationsDemo.Todo(
                        id: todo.id,
                        name: todo.name,
                        dateCompleted: todo.isComplete ? .now : nil
                    )
                }
                let encoder = JSONEncoder()
                let v2Data = try encoder.encode(v2Todos)
                try fileProvider.write(data: v2Data, to: fileURL)
            }
        }
    }
}

