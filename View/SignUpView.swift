import SwiftUI

struct SignUpView: View {
  @Environment(\.dismiss) var dismiss
  @State private var name = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(alignment: .leading, spacing: 20) {
        // Custom Back Button
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.white)
            .font(.title2)
        }
        .padding(.bottom, 20)

        Text("Sign Up")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

        CustomTextField(placeholder: "Name", text: $name)
        CustomTextField(placeholder: "Email", text: $email)
        CustomTextField(
          placeholder: "Password",
          text: $password,
          isSecure: true
        )
        CustomTextField(
          placeholder: "Confirm Password",
          text: $confirmPassword,
          isSecure: true
        )

        Spacer()

        NavigationLink(destination: VerificationView()) {
          
          GradientButton(title: "Sign Up") {}
        }
        
        .disabled(
          name.isEmpty || email.isEmpty || password.isEmpty ||
            password != confirmPassword
        )

      }
      .padding()
    }
    .navigationBarHidden(true)
  }
}
