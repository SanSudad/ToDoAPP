
import SwiftUI

struct AuthTextField: View {
  let placeholder: String
  @Binding var text: String
  var isSecure: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(placeholder)
        .font(.headline)
        .foregroundColor(.white)

      if isSecure {
        SecureField("", text: $text)
          .padding()
          .background(Color.gray.opacity(0.2))
          .cornerRadius(12)
          .foregroundColor(.white)
          .tint(.purple)
      } else {
        TextField("", text: $text)
          .padding()
          .background(Color.gray.opacity(0.2))
          .cornerRadius(12)
          .foregroundColor(.white)
          .tint(.purple)
          .autocapitalization(.none)
          .keyboardType(.default)
      }
    }
  }
}
