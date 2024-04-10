//
//  Habit.swift
//  LIA1_Test_App
//
//  Created by Kanyaton Somjit on 2024-04-10.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    
    @DocumentID var id : String?
    var ItemName : String
    var done : Bool = false
    var latest : Date?
}
