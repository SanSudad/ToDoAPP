import SwiftUI

struct ForgotPasswordView: View {
  @Environment(\.dismiss) var dismiss
  @State private var email = ""

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

        Text("Forgot Password")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

        Text(
          "Enter the email address associated with your account to reset your password."
        )
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.7))
        .padding(.bottom, 20)

        CustomTextField(placeholder: "Email", text: $email)

        Spacer()

        NavigationLink(destination: VerificationView()) {
          GradientButton(title: "Continue") {}
        }
        .disabled(email.isEmpty)
      }
      .padding()
    }
    .navigationBarHidden(true)
  }
}
