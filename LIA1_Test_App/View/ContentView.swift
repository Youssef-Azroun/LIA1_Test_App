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
                    } else {
                        VStack {
                            Spacer()
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.orange)
                            Text("Welcome to Habit List!")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Track your habits efficiently. Please log in to your account to get started.")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                    }
                    Spacer()
                    if authViewModel.isUserAuthenticated {
                        HabitListView()
                            .padding()
                    }
                }
            }
        }
        
    }
}

struct RowView: View {
    let habit : Habit
    let vm : HabitListVm
    
    var body: some View {
        
        HStack {
            Text(habit.ItemName)
            Spacer()
            Text(habit.streak == 0 ? "" : String(habit.streak))
            Button(action: {
                vm.toggle(habit: habit)
            }){
                Image(systemName: habit.done ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

