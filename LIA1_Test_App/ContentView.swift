//
//  ContentView.swift
//  LIA1_Test_App
//
//  Created by Youssef Azroun on 2024-04-09.
//
//Youssef Azroun

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        if authViewModel.isUserAuthenticated {
                            NavigationLink(destination: MyAccountView().environmentObject(authViewModel)) {
                                Text("My Account")
                            }
                            .padding()
                            .background(Color.orange.opacity(0.8))                            .foregroundColor(.white)
                            .cornerRadius(20)
                        } else {
                            Button("Log In") {
                                authViewModel.showLoginView = true
                            }
                            .sheet(isPresented: $authViewModel.showLoginView) {
                                LoginView()
                                    .environmentObject(authViewModel)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.top, 5)
                    .padding(.trailing, 10)
                    
                    if authViewModel.isUserAuthenticated {
                        Text("Welcome, \(authViewModel.user?.name ?? "User")!")
                            .padding()
                    }
                    Spacer()
                    
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

