//
//  SignupView.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    @State private var registrationSuccessful = false
    
    private func signUpWithEmailPassword() {
        Task {
            viewModel.register { success in
                if success {
                    registrationSuccessful = true
                }
            }
        }
    }
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "Color")
    }



    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

       var btnBack : some View { Button(action: {
           self.presentationMode.wrappedValue.dismiss()
           }) {
               HStack {
                   Image(systemName: "arrow.left")
                   .aspectRatio(contentMode: .fit)
                   .foregroundColor(.blue)
                   Text("Login")
               }
           }
       }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Color").edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack {
                        Image("logo1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 200, maxHeight: 280)
                        Text("Sign up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        //1
                        HStack {
                            Image(systemName: "at")
                            TextField("Email", text: $viewModel.email)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .focused($focus, equals: .email)
                                .submitLabel(.next)
                                .onSubmit {
                                    self.focus = .password
                                }
                                .accessibilityLabel("Email")
                        }
                        .padding(.vertical, 6)
                        .background(Divider(), alignment: .bottom)
                        .padding(.bottom, 4)
                        
                        //2
                        
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $viewModel.password)
                                .focused($focus, equals: .password)
                                .submitLabel(.next)
                                .onSubmit {
                                    self.focus = .confirmPassword
                                }
                                .accessibilityLabel("Contraseña")
                        }
                        .padding(.vertical, 6)
                        .background(Divider(), alignment: .bottom)
                        .padding(.bottom, 8)
                        
                        //3
                        
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Confirm password", text: $viewModel.confirmPassword)
                                .focused($focus, equals: .confirmPassword)
                                .submitLabel(.go)
                                .onSubmit {
                                    signUpWithEmailPassword()
                                }
                                .accessibilityLabel("Confirmar contraseña")
                        }
                        .padding(.vertical, 6)
                        .background(Divider(), alignment: .bottom)
                        .padding(.bottom, 8)
                        
                        //ErrorMessage
                        if !viewModel.errorMessage.isEmpty {
                            VStack {
                                Text(viewModel.errorMessage)
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor.systemRed))
                            }
                        }
                        
                        //ButtonView
                        Button(action: signUpWithEmailPassword) {
                            if viewModel.authenticationState != .authenticating {
                                Text("Sign up")
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                            }
                            else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .disabled(!viewModel.isValid)
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel(viewModel.authenticationState != .authenticating ? "Registrarse" : "Cargando")
                        
                        HStack {
                            Text("Forgot your password?")
                                .multilineTextAlignment(.center)
                            NavigationLink(destination: ForgotPasswordView()) {
                                Text("Recuperate")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                    .onAppear {
                        viewModel.resetFields()
                    }
                    
                    //.navigationBarBackButtonHidden(true)
                    //.navigationBarItems(leading: btnBack)
                    .listStyle(.plain)
                    .padding()
                }
                .alert(isPresented: $registrationSuccessful) {
                    Alert(title: Text("Registro Exitoso"),
                          message: Text("Se ha enviado un correo electrónico para verificar su cuenta."),
                          dismissButton: .default(Text("Ok"), action: {
                        dismiss()
                    }))
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupView()
                //.preferredColorScheme(.dark)
                .environmentObject(AuthenticationViewModel())
        }
    }
}
