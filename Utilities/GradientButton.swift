import SwiftUI

struct GradientButton: View {
  var title: String
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [Color.purple2, Color.purple3],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .cornerRadius(12)
    }
  }
}
