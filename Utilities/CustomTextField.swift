

import SwiftUI

struct CustomTextField: View {
  var placeholder: String
  @Binding var text: String
  var isSecure: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      
      ZStack(alignment: .leading) {
       
        if text.isEmpty {
          Text(placeholder)
            .foregroundColor(.white.opacity(0.6)) 
            .padding(.leading)
        }

      
        Group {
          if isSecure {
            SecureField("", text: $text)
          } else {
            TextField("", text: $text)
              .keyboardType(
                placeholder.lowercased().contains("email") ? .emailAddress :
                  .default
              )
              .textInputAutocapitalization(.never)
          }
        }
        .foregroundColor(.white)         .padding(.leading)
        .frame(height: 50)
      }

      
      Rectangle()
        .frame(height: 1)
        .foregroundColor(.gray.opacity(0.5))
    }
  }
}
