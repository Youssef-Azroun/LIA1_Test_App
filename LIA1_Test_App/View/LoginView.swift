//
//  LoginView.swift
//  LIA1_Test_App
//
//  Created by Youssef Azroun on 2024-04-10.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .foregroundColor(.black)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(.black)
                        }
                        Button(action: { self.isPasswordVisible.toggle() }) {
                            Image(systemName: self.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    
                    Button("Log In") {
                        authViewModel.logIn(email: email, password: password)
                    }
                    .alert(isPresented: $authViewModel.loginFailed) {
                        Alert(title: Text("Log in failed"), message: Text("Please check your credentials and try again."), dismissButton: .default(Text("OK")))
                    }
                    .padding()
                    .background(Color.orange.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    NavigationLink("Create Account", destination: SignUpView().environmentObject(authViewModel))
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding()
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

