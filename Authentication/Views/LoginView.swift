//
//  LoginView.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    @State private var showDetails = false
    @State private var isGoogleSignInLoading = false

    
    private func signInWithEmail() {
        Task {
            viewModel.login { success in
                if success {
                    dismiss()
                    showDetails = true
                }
            }
        }
    }
    
    private func signInWithGoogle() {
        isGoogleSignInLoading = true
        Task {
            let success = await viewModel.signInWithGoogle()
            isGoogleSignInLoading = false
            if success {
                dismiss()
                showDetails = true
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
                        Text("Login")
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
                            
                        }
                        .padding(.vertical, 6)
                        .background(Divider(), alignment: .bottom)
                        .padding(.bottom, 4)
                        
                        //2
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $viewModel.password)
                                .focused($focus, equals: .password)
                                .submitLabel(.go)
                                .onSubmit {
                                    signInWithEmail()
                                }
                            
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
                        Button(action: signInWithEmail ) {
                            if viewModel.authenticationState != .authenticating {
                                Text("Login")
                                    .foregroundColor(.white)
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
                        // .disabled(!viewModel.isValid)
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        
                        HStack {
                            VStack { Divider() }
                            Text("or")
                            VStack { Divider() }
                        }
                        
                        Button(action: signInWithGoogle) {
                            if isGoogleSignInLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Sign in with Google")
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(alignment: .leading) {
                                        Image("Google")
                                            .frame(width: 30, alignment: .center)
                                    }
                            }
                        }

                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .buttonStyle(.bordered)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up with Email")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(alignment: .leading) {
                                Image(systemName: "envelope")
                                    .font(.title2)
                                    .frame(width: 30, alignment: .center)
                            }
                            .onAppear { viewModel.switchFlow() }
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .buttonStyle(.bordered)
                    .padding(.top, 12)
                    
                }
                .onAppear {
                    viewModel.resetFields()
                }
                .navigationBarHidden(true)
                .listStyle(.plain)
                .padding()
                .navigationDestination(isPresented: $showDetails) {
                    ContentView()
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            //.preferredColorScheme(.dark)
        }
        .environmentObject(AuthenticationViewModel())
    }
}
