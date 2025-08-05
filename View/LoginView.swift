import SwiftUI


struct LoginView: View {
    @Binding var isUserLoggedIn: Bool

  @State private var email = ""
  @State private var password = ""

  var body: some View {
    ZStack {
      Color.black2.ignoresSafeArea()

      VStack(spacing: 20) {
        Spacer()

        Text("Login")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

       
        CustomTextField(placeholder: "Email", text: $email)
        CustomTextField(
          placeholder: "Password",
          text: $password,
          isSecure: true
        )

        HStack {
          Spacer()
          NavigationLink(
            "Forgot Password?",
            destination: ForgotPasswordView()
          )
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.8))
        }

        Spacer().frame(height: 20)

        GradientButton(title: "Login") {
         
          isUserLoggedIn = true
        }

        Button(action: {}) {
          HStack {
           
            Image(systemName: "globe")
                  .scaledToFit()
                  .fixedSize(horizontal: false, vertical: true)
            Text("Continue with Google")
          }
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.gray.opacity(0.2))
          .cornerRadius(12)
        }

        Spacer()

        HStack {
          Text("Don't have an account?")
            .foregroundColor(.white.opacity(0.7))
          NavigationLink("Sign Up", destination: SignUpView())
            .fontWeight(.bold)
            .foregroundColor(Color.purple2)
        }
      }
      .padding()
    }
    .foregroundColor(Color.black2)
    .navigationBarHidden(true)
  }
}


#Preview {

}
