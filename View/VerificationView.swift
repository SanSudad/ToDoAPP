import SwiftUI

struct VerificationView: View {
  @Environment(\.dismiss) var dismiss
  @State private var code = ""

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(alignment: .leading, spacing: 20) {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.white)
            .font(.title2)
        }
        .padding(.bottom, 20)

        Text("Verification")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

        Text("Enter the 6-digit verification code sent to your email.")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.7))
          .padding(.bottom, 20)

        
        CustomTextField(placeholder: "------", text: $code)
          .keyboardType(.numberPad)

        Spacer()

        NavigationLink(destination: NewPasswordView()) {
          GradientButton(title: "Verify") {}
        }
        .disabled(code.count != 6)
      }
      .padding()
    }
    .navigationBarHidden(true)
  }
}
