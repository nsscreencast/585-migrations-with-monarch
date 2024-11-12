import SwiftUI
import Monarch

@main
struct MigrationsDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(fileProvider: FileManager.default)
                .runMigrations {
                    MigrationGroup {
                        Migrations.v1.MigrateTodo_IncludeDateCompleted()
                    }
                    .migrationDependency(FileManager.default as FileProvider)
                }
        }
    }
}
