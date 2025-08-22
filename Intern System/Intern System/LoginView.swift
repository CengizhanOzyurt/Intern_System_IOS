import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    @State private var navigate = false
    @State private var loggedInName: String = ""

    struct SecureTextField: View {
        @State private var isSecureField: Bool = true
        @Binding var text: String
        var body: some View {
            HStack {
                if isSecureField { SecureField("Password", text: $text) }
                else { TextField("Password", text: $text) }
            }
            .overlay(alignment: .trailing) {
                Image(systemName: isSecureField ? "eye.slash" : "eye")
                    .onTapGesture { isSecureField.toggle() }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("WELCOME TO THE INTERN SYSTEM")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(red: 17/255, green: 28/255, blue: 102/255))
                    .padding()
                    .offset(y: 300)

                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .offset(y: 130)
                    .frame(width: 300, height: 500)

                VStack {
                    TextField("e-mail", text: $email)
                        .padding(15)
                        .frame(width: 330, height: 50)
                        .textInputAutocapitalization(.never)
                        .foregroundStyle(Color(.gray))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 63/255, green: 165/255, blue: 203/255), lineWidth: 1)
                        }

                    SecureTextField(text: $password)
                        .padding(15)
                        .frame(width: 330, height: 50)
                        .textInputAutocapitalization(.never)
                        .foregroundStyle(Color(.gray))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 63/255, green: 165/255, blue: 203/255), lineWidth: 1)
                        }

                    Button {
                        guard !isLoading, !email.isEmpty, !password.isEmpty else { return }
                        Task { await loginFlow() }
                    } label: {
                        if isLoading {
                            ProgressView().tint(.white).frame(width: 70, height: 40)
                        } else {
                            Text("Login")
                                .frame(width: 70)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 63/255, green: 165/255, blue: 203/255))
                                .cornerRadius(10)
                        }
                    }
                    .disabled(isLoading || email.isEmpty || password.isEmpty)

                    if let err = errorMessage {
                        Text(err).foregroundColor(.red).padding(.top, 10)
                    }

                    HStack {
                        Text("Don't have an account?").bold()
                        Button("Sign up") { }
                    }
                    .offset(y: 20)
                }

                NavigationLink(
                    destination: HomeView(fullName: loggedInName),
                    isActive: $navigate
                ) { EmptyView() }
            }
            .padding()
            .background(.white)
            .padding(.horizontal, 20)
            .offset(y: -200)
        }
    }

    @MainActor
    private func loginFlow() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let text = try await APIClient.shared.login(email: email, password: password)

            if let data = text.data(using: .utf8),
               let payload = try? JSONDecoder().decode(LoginPayload.self, from: data) {

                let nested = payload.user
                let computedName: String? = {
                    if let full = payload.fullName ?? nested?.fullName { return full }
                    let first = payload.firstName ?? nested?.firstName
                    let last  = payload.lastName  ?? nested?.lastName
                    let parts = [first, last].compactMap { $0 }
                    return parts.isEmpty ? nil : parts.joined(separator: " ")
                }()

                if let name = computedName, !name.isEmpty {
                    loggedInName = name
                } else if let msg = payload.message, !msg.isEmpty {
                    loggedInName = msg
                } else {
                    loggedInName = "Kullanıcı"
                }
            } else {
                loggedInName = text.isEmpty ? "Kullanıcı" : text
            }


            navigate = true

        } catch let api as APIError {
            errorMessage = api.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct LoginPayload: Codable {
    let message: String?
    let accessToken: String?
    let token: String?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let user: NestedUser?
    struct NestedUser: Codable {
        let firstName: String?
        let lastName: String?
        let fullName: String?
        let name: String?
    }
}

#Preview { LoginView() }
