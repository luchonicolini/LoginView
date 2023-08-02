//
//  AuthenticationViewModel.swift
//  LoginFirebase
//
//  Created by Luciano Nicolini on 27/07/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthenticationFlow {
  case login
  case signUp
}

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isValid: Bool  = false
    @Published var errorMessage: String = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var flow: AuthenticationFlow = .login
    @Published var user: User?
    @Published var displayName: String = ""
    
    init() {
      registerAuthStateHandler()

      $flow
        .combineLatest($email, $password, $confirmPassword)
        .map { flow, email, password, confirmPassword in
          flow == .login
          ? !(email.isEmpty || password.isEmpty)
          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
        }
        .assign(to: &$isValid)
    }
    
    func resetFields() {
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
    }


    private var authStateHandler: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
      if authStateHandler == nil {
        authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
          self.user = user
          self.authenticationState = user == nil ? .unauthenticated : .authenticated
          self.displayName = user?.email ?? ""
        }
      }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""  // <-- limpiar el mensaje de error
    }
}


extension AuthenticationViewModel {
    // MARK: - Login
    
    func login(completion: @escaping (Bool) -> Void) {
        authenticationState = .authenticating
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.authenticationState = .unauthenticated
                completion(false)
            } else {
                guard let user = Auth.auth().currentUser else {
                    self.authenticationState = .unauthenticated
                    completion(false)
                    return
                }
                
                if !user.isEmailVerified {
                    self.errorMessage = "Por favor, verifica tu dirección de correo electrónico antes de iniciar sesión."
                    self.authenticationState = .unauthenticated
                    completion(false)
                } else {
                    self.authenticationState = .authenticated
                    self.email = ""
                    self.password = ""
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Register
    
    func register(completion: @escaping (Bool) -> Void) {
        authenticationState = .authenticating
        
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden"
            authenticationState = .unauthenticated
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            self.authenticationState = .unauthenticated
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                 self.email = ""
                 self.password = ""
                 self.confirmPassword = ""
                 completion(false)
                 return
             }
            
            self.sendEmailVerification(for: user, completion: completion)
        }
    }
    
    // MARK: - Email Verification
    
    private func sendEmailVerification(for user: User, completion: @escaping (Bool) -> Void) {
        user.sendEmailVerification { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
               // self.signOut()
                self.authenticationState = .unauthenticated
                completion(false)
                return
            }
            
            self.authenticationState = .authenticated
            completion(true)
        }
    }
    
}

// MARK: - Google Sign-In

enum AuthenticationError: Error {
  case tokenError(message: String)
}

extension AuthenticationViewModel {
  func signInWithGoogle() async -> Bool {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase configuration")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      print("There is no root view controller!")
      return false
    }

      do {
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        let user = userAuthentication.user
        guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
        let accessToken = user.accessToken

        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)

        let result = try await Auth.auth().signIn(with: credential)
        let firebaseUser = result.user
        print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
        return true
      }
      catch {
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
        return false
      }
  }
}

