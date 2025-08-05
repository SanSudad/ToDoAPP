import SwiftUI

struct NewPasswordView: View {
  @Environment(\.dismiss) var dismiss
  @State private var newPassword = ""
  @State private var confirmPassword = ""

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

        Text("New Password")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

        CustomTextField(
          placeholder: "New Password",
          text: $newPassword,
          isSecure: true
        )
        CustomTextField(
          placeholder: "Confirm New Password",
          text: $confirmPassword,
          isSecure: true
        )

        Spacer()

        GradientButton(title: "Change Password") {
          print("Password Changed!")
          dismiss()
        }
        .disabled(
          newPassword.isEmpty || newPassword != confirmPassword
        )
      }
      .padding()
    }
    .navigationBarHidden(true)
  }
}
