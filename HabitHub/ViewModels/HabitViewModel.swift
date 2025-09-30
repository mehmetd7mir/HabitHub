//
//  HabitViewModel.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class HabitViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var targetDays: Int = 30
    @Published var isActive: Bool = true
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func saveHabit() -> Bool {
        // Validation
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        guard name.count >= 3 else {
            return false
        }
        
        guard targetDays >= 1 && targetDays <= 365 else {
            return false
        }
        
        // Create new habit
        let habit = Habit(context: viewContext)
        habit.id = UUID()
        habit.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        habit.createdDate = Date()
        habit.targetDays = Int32(targetDays)
        habit.isActive = isActive
        
        do {
            try viewContext.save()
            resetForm()
            return true
        } catch {
            print("Error saving habit: \(error)")
            return false
        }
    }
    
    func resetForm() {
        name = ""
        targetDays = 30
        isActive = true
    }
    
    var isFormValid: Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               name.count >= 3 &&
               targetDays >= 1 &&
               targetDays <= 365
    }
}
