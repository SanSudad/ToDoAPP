import SwiftUI
import SwiftData

@main
struct ToDoAppFLApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: TodoItem.self)
    }
}
