//
//  HabitLogViewModel.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class HabitLogViewModel: ObservableObject {
    @Published var todayHabits: [HabitWithLog] = []
    
    private let viewContext: NSManagedObjectContext
    private let calendar = Calendar.current
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        loadTodayHabits()
    }
    
    func loadTodayHabits() {
        let today = calendar.startOfDay(for: Date())
        
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)]
        
        do {
            let habits = try viewContext.fetch(request)
            todayHabits = habits.map { habit in
                let log = getOrCreateLog(for: habit, date: today)
                return HabitWithLog(habit: habit, log: log)
            }
        } catch {
            print("Error loading today's habits: \(error)")
            todayHabits = []
            // Show user-friendly error if needed
        }
    }
    
    func toggleHabitCompletion(_ habitWithLog: HabitWithLog) {
        habitWithLog.log.isCompleted.toggle()
        
        do {
            try viewContext.save()
            if habitWithLog.log.isCompleted {
                Haptics.success()
            } else {
                Haptics.lightImpact()
            }
            // Reload to update UI
            loadTodayHabits()
        } catch {
            print("Error toggling habit completion: \(error)")
            Haptics.error()
        }
    }
    
    private func getOrCreateLog(for habit: Habit, date: Date) -> HabitLog {
        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        request.predicate = NSPredicate(format: "habit == %@ AND date == %@", habit, date as NSDate)
        request.fetchLimit = 1
        
        do {
            let logs = try viewContext.fetch(request)
            if let existingLog = logs.first {
                return existingLog
            }
        } catch {
            print("Error fetching existing log: \(error)")
        }
        
        // Create new log if none exists
        let newLog = HabitLog(context: viewContext)
        newLog.id = UUID()
        newLog.date = date
        newLog.isCompleted = false
        newLog.habit = habit
        
        return newLog
    }
    
    var todayProgress: Double {
        guard !todayHabits.isEmpty else { return 0.0 }
        let completedCount = todayHabits.filter { $0.log.isCompleted }.count
        return Double(completedCount) / Double(todayHabits.count)
    }
    
    var completedCount: Int {
        todayHabits.filter { $0.log.isCompleted }.count
    }
    
    var totalCount: Int {
        todayHabits.count
    }
}

struct HabitWithLog: Identifiable {
    let id = UUID()
    let habit: Habit
    let log: HabitLog
}
