//
//  HabitListView.swift
//  LIA1_Test_App
//
//  Created by Kanyaton Somjit on 2024-04-10.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var habitListVM = HabitListVm()
    @State var showingAddAlert = false
    @State var newHabitName = ""
    
    var body: some View {
        VStack {
            Spacer()
            List {
                ForEach(habitListVM.habits) { habit in
                    RowView(habit: habit, vm: habitListVM)
                }
                .onDelete() { indexSet in
                    for index in indexSet {
                        habitListVM.delete(index: index)
                    }
                }
            }
            Spacer()
            Button(action: {
                showingAddAlert = true
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(Color.white)
                    .padding(.leading)
                Text("Add new habit")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .padding([.top, .bottom, .trailing])
            }
            .background(Color.orange.opacity(0.8))
            .cornerRadius(40.0)
            .alert("Lägg till", isPresented: $showingAddAlert) {
                TextField("Lägg till", text: $newHabitName)
                Button("Add", action: {
                    habitListVM.saveToFirestore(habitName: newHabitName)
                    newHabitName = ""
                })
            }
        }.onAppear() {
            habitListVM.listenToFirestore()
        }
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}
