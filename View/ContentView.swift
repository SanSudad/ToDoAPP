
import SwiftUI

struct ContentView: View {
  @State private var isLoggedIn = false

  var body: some View {
    if isLoggedIn {
      
      HomeView(isUserLoggedIn: $isLoggedIn)
    } else {
      LoginView(isUserLoggedIn: $isLoggedIn)
    }
  }
}
