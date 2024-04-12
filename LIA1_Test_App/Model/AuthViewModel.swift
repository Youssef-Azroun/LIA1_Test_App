//
//  AuthViewModel.swift
//  LIA1_Test_App
//
//  Created by Youssef Azroun on 2024-04-10.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var showLoginView = false
    @Published var showSignUpView = false
    @Published var user: User?
    @Published var loginFailed = false
    @Published var signUpFailed = false
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.isUserAuthenticated = true
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let name = data?["name"] as? String ?? ""
                        let email = data?["email"] as? String ?? ""
                        DispatchQueue.main.async {
                            self.user = User(name: name, email: email)
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                self.isUserAuthenticated = false
            }
        }
    }
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.loginFailed = true
                }
                return
            }
            // On successful login:
            self.isUserAuthenticated = true
            self.showLoginView = false
            // Fetch user details from Firestore
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid ?? ""
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    DispatchQueue.main.async {
                        self.user = User(name: name, email: email)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func signUp(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.signUpFailed = true
                }
                return
            }
            // On successful sign-up:
            guard let user = authResult?.user else { return }
            self.user = User(name: name, email: user.email ?? "")
            self.isUserAuthenticated = true
            self.showSignUpView = false
            
            // Save user details to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isUserAuthenticated = false
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func updateUsername(newUsername: String) {
        guard let user = Auth.auth().currentUser else { return }
        // Update username in your backend, e.g., Firestore
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData(["name": newUsername]) { error in
            if let error = error {
                print("Error updating username: \(error)")
            } else {
                self.user?.name = newUsername
                print("Username successfully updated")
            }
        }
    }
}
