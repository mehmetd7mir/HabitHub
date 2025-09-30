//
//  StreakCalculator.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import CoreData

struct StreakCalculator {
    static func calculateCurrentStreak(for habit: Habit, context: NSManagedObjectContext) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentStreak = 0
        var currentDate = today
        
        while true {
            let isCompleted = isHabitCompletedOnDate(habit: habit, date: currentDate, context: context)
            
            if isCompleted {
                currentStreak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return currentStreak
    }
    
    static func calculateLongestStreak(for habit: Habit, context: NSManagedObjectContext) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = habit.createdDate ?? today
        var longestStreak = 0
        var currentStreak = 0
        var currentDate = startDate
        
        while currentDate <= today {
            let isCompleted = isHabitCompletedOnDate(habit: habit, date: currentDate, context: context)
            
            if isCompleted {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 0
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return longestStreak
    }
    
    static func calculateCompletionRate(for habit: Habit, context: NSManagedObjectContext, days: Int = 30) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -days, to: today) ?? today
        
        var completedDays = 0
        var currentDate = startDate
        
        while currentDate <= today {
            if isHabitCompletedOnDate(habit: habit, date: currentDate, context: context) {
                completedDays += 1
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return Double(completedDays) / Double(days)
    }
    
    static func getCompletionHistory(for habit: Habit, context: NSManagedObjectContext, days: Int = 30) -> [Date: Bool] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -days, to: today) ?? today
        
        var history: [Date: Bool] = [:]
        var currentDate = startDate
        
        while currentDate <= today {
            history[currentDate] = isHabitCompletedOnDate(habit: habit, date: currentDate, context: context)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return history
    }
    
    private static func isHabitCompletedOnDate(habit: Habit, date: Date, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        request.predicate = NSPredicate(format: "habit == %@ AND date == %@", habit, date as NSDate)
        request.fetchLimit = 1
        
        do {
            let logs = try context.fetch(request)
            return logs.first?.isCompleted ?? false
        } catch {
            print("Error checking habit completion: \(error)")
            return false
        }
    }
}

struct HabitStats {
    let currentStreak: Int
    let longestStreak: Int
    let completionRate: Double
    let totalDays: Int
    let completedDays: Int
}
