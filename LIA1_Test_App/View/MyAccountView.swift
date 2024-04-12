//
//  MyAccountView.swift
//  LIA1_Test_App
//
//  Created by Youssef Azroun on 2024-04-10.
//

import SwiftUI

struct MyAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditingUsername = false
    @State private var newUsername = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("My info:")
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .frame(height: 150)
                    .shadow(radius: 10)
                    .overlay(
                        VStack {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                Text("Name: \(authViewModel.user?.name ?? "N/A")")
                                Button(action: { self.isEditingUsername.toggle() }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24)) // Adjust the size as needed
                                }
                            }
                            if isEditingUsername {
                                TextField("New username", text: $newUsername)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button("Update") {
                                    authViewModel.updateUsername(newUsername: newUsername)
                                    self.isEditingUsername = false
                                }
                            }
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                Text("Email: \(authViewModel.user?.email ?? "N/A")")
                            }
                        }
                    )
                Button("Log Out") {
                    authViewModel.logOut()
                }
                .padding()
                .background(Color.orange.opacity(0.8)) // Changed to dark orange
                .foregroundColor(.white) // Text color changed to white
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
