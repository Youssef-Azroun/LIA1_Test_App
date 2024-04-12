//
//  HabitListVm.swift
//  LIA1_Test_App
//
//  Created by Kanyaton Somjit on 2024-04-10.
//

import Foundation
import Firebase

class HabitListVm : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let date = Date()
    
    @Published var habits = [Habit]()
    
    func toggle (habit : Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            habitRef.document(id).updateData(["done" : !habit.done])
        
            if habit.done == false {
                if habit.latest != date {
                    habitRef.document(id).updateData(["latest" : date])
                }
                let newStreak = habit.streak + 1
                habitRef.document(id).updateData(["streak" : newStreak])
            }
        }
    }
    
    func updateStreak(habit: Habit) {
        guard let user = auth.currentUser else {return }
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let calendar = Calendar.current
        let today = Date()
        var newStreak = habit.streak
        
        if let dayDifference = calendar.dateComponents([.day], from: habit.latest ?? today, to: today).day {
            if dayDifference > 1 {
                newStreak = 0
                
                if let id = habit.id{
                    habitRef.document(id).updateData(["streak" : newStreak])
                }
            }
        }
    }
    
    
    func saveToFirestore(habitName: String) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(ItemName: habitName)
        do {
            try habitRef.addDocument(from: habit)
        } catch {
            print("Error saving to db")
        }
    }
    
    func listenToFirestore() {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        habitRef.addSnapshotListener() {
            snapshot, err in
                
            guard let snapshot = snapshot else {return}
                
            if let err = err {
                print("error getting document \(err)")
            } else {
                self.habits.removeAll()
                for document in snapshot.documents {
                    do {
                        var habit = try document.data(as : Habit.self)
                        let today = Date()
                        let calendar = Calendar.current
                        var dateComponents = DateComponents()
                        dateComponents.day = -1

                        if let yesterday = calendar.date(byAdding: dateComponents, to: today) {
                            if calendar.isDate(habit.latest ?? yesterday, inSameDayAs: today) {
                                habit.done = true
                            } else {
                                habit.done = false
                            }
                        }
                        self.updateStreak(habit: habit)
                        self.habits.append(habit)
                    } catch {
                        print("Error reading from db")
                    }
                }
            }
        }
    }
    
    func delete(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
            
        let habit = habits[index]
        if let id = habit.id {
            habitRef.document(id).delete()
        }
    }
    
}
