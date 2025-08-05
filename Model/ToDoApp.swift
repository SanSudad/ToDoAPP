

import SwiftUI
import SwiftData

@main
struct ToDoAppFLApp: App {
  @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false

  var body: some Scene {
    WindowGroup {
      if isUserLoggedIn {
        
        HomeView(isUserLoggedIn: $isUserLoggedIn)
      } else {
        NavigationStack {
          LoginView(isUserLoggedIn: $isUserLoggedIn)
        }
      }
    }
    .modelContainer(for: TodoItem.self)
  }
}
