//
//  ForgotPasswordView.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isResettingPassword = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func isValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func resetPassword() {
        if isValid(email: email) {
            isResettingPassword = true
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                self.isResettingPassword = false
                
                if let error = error {
                    self.showAlert = true
                    self.alertMessage = error.localizedDescription
                } else {
                    self.showAlert = true
                    self.alertMessage = "Se ha enviado un correo electrónico para restablecer la contraseña"
                }
            }
        } else {
            self.alertMessage = "Por favor, introduce un correo electrónico válido."
            self.showAlert = true
        }
    }
    
    
    var body: some View {
        NavigationStack  {
            ZStack {
                Color("Color").edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Image("logo1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 150, maxHeight: 250)
                            .padding(.top, 20)
                        
                        Text("Password recovery")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Enter your email address and we will send you a link to reset your password.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        HStack {
                            Image(systemName: "at")
                            TextField("Email", text: $viewModel.email)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                             
                        }
                        .padding(.vertical, 6)
                        .background(Divider(), alignment: .bottom)
                        .padding(.bottom, 4)
                        
                        if isResettingPassword {
                            ProgressView()
                                .scaleEffect(1)
                                .padding(.top, 20)
                        }
                        
                        Button(action: resetPassword) {
                            Text("Send link")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Información"), message: Text(alertMessage), dismissButton: .default(Text("Ok"), action: {
                            if alertMessage == "Se ha enviado un correo electrónico para restablecer la contraseña" {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }))
                    }
                }
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForgotPasswordView()
                //.preferredColorScheme(.dark)
                .environmentObject(AuthenticationViewModel())
        }
    }
}
