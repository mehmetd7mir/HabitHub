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
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            print("Validation failed: Habit name is empty")
            return false
        }
        
        guard trimmedName.count >= 3 else {
            print("Validation failed: Habit name too short (\(trimmedName.count) characters)")
            return false
        }
        
        guard targetDays >= 1 && targetDays <= 365 else {
            print("Validation failed: Target days out of range (\(targetDays))")
            return false
        }
        
        // Create new habit
        let habit = Habit(context: viewContext)
        habit.id = UUID()
        habit.name = trimmedName
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
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty &&
               trimmedName.count >= 3 &&
               targetDays >= 1 &&
               targetDays <= 365
    }
}
