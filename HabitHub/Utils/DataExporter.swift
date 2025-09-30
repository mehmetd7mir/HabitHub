//
//  DataExporter.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import CoreData
import SwiftUI

struct DataExporter {
    static func exportToCSV(context: NSManagedObjectContext) -> URL? {
        let habits = fetchAllHabits(context: context)
        let habitLogs = fetchAllHabitLogs(context: context)
        
        var csvContent = "Habit Name,Target Days,Active,Created Date,Completion Date,Completed\n"
        
        for habit in habits {
            let habitLogsForHabit = habitLogs.filter { $0.habit == habit }
            
            if habitLogsForHabit.isEmpty {
                // Habit without logs
                csvContent += "\"\(habit.name ?? "")\",\(habit.targetDays),\(habit.isActive),\"\(formatDate(habit.createdDate ?? Date()))\",,\n"
            } else {
                // Habit with logs
                for log in habitLogsForHabit {
                    csvContent += "\"\(habit.name ?? "")\",\(habit.targetDays),\(habit.isActive),\"\(formatDate(habit.createdDate ?? Date()))\",\"\(formatDate(log.date ?? Date()))\",\(log.isCompleted)\n"
                }
            }
        }
        
        return saveToFile(content: csvContent, filename: "habits_export.csv")
    }
    
    static func exportToJSON(context: NSManagedObjectContext) -> URL? {
        let habits = fetchAllHabits(context: context)
        let habitLogs = fetchAllHabitLogs(context: context)
        
        var exportData: [String: Any] = [:]
        exportData["export_date"] = formatDate(Date())
        exportData["version"] = "1.0"
        
        var habitsData: [[String: Any]] = []
        
        for habit in habits {
            let habitLogsForHabit = habitLogs.filter { $0.habit == habit }
            
            var habitData: [String: Any] = [:]
            habitData["id"] = habit.id?.uuidString
            habitData["name"] = habit.name
            habitData["target_days"] = habit.targetDays
            habitData["is_active"] = habit.isActive
            habitData["created_date"] = formatDate(habit.createdDate ?? Date())
            
            var logsData: [[String: Any]] = []
            for log in habitLogsForHabit {
                var logData: [String: Any] = [:]
                logData["id"] = log.id?.uuidString
                logData["date"] = formatDate(log.date ?? Date())
                logData["is_completed"] = log.isCompleted
                logsData.append(logData)
            }
            
            habitData["logs"] = logsData
            habitsData.append(habitData)
        }
        
        exportData["habits"] = habitsData
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            return saveToFile(content: jsonString, filename: "habits_backup.json")
        } catch {
            print("Error creating JSON: \(error)")
            return nil
        }
    }
    
    private static func fetchAllHabits(context: NSManagedObjectContext) -> [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    private static func fetchAllHabitLogs(context: NSManagedObjectContext) -> [HabitLog] {
        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitLog.date, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching habit logs: \(error)")
            return []
        }
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
    
    private static func saveToFile(content: String, filename: String) -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
}

struct BackupManager {
    static func createBackup(context: NSManagedObjectContext) -> URL? {
        return DataExporter.exportToJSON(context: context)
    }
    
    static func importFromJSON(context: NSManagedObjectContext, url: URL) throws {
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let habits = json?["habits"] as? [[String: Any]] else { 
            throw NSError(domain: "DataExporter", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format or missing habits data"])
        }
        
        // Simple restore: insert all as new records
        for habitData in habits {
            let habit = Habit(context: context)
            habit.id = UUID(uuidString: (habitData["id"] as? String) ?? UUID().uuidString)
            habit.name = habitData["name"] as? String
            habit.targetDays = Int32(habitData["target_days"] as? Int ?? 0)
            habit.isActive = habitData["is_active"] as? Bool ?? true
            if let created = habitData["created_date"] as? String, let date = ISO8601DateFormatter().date(from: created) {
                habit.createdDate = date
            } else {
                habit.createdDate = Date()
            }
            if let logs = habitData["logs"] as? [[String: Any]] {
                for logData in logs {
                    let log = HabitLog(context: context)
                    log.id = UUID(uuidString: (logData["id"] as? String) ?? UUID().uuidString)
                    if let d = logData["date"] as? String, let date = ISO8601DateFormatter().date(from: d) {
                        log.date = Calendar.current.startOfDay(for: date)
                    } else {
                        log.date = Calendar.current.startOfDay(for: Date())
                    }
                    log.isCompleted = logData["is_completed"] as? Bool ?? false
                    log.habit = habit
                }
            }
        }
        do {
            try context.save()
        } catch {
            throw NSError(domain: "DataExporter", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to save imported data: \(error.localizedDescription)"])
        }
    }
    
    static func shareBackup(context: NSManagedObjectContext) -> [Any] {
        var items: [Any] = []
        
        if let csvURL = DataExporter.exportToCSV(context: context) {
            items.append(csvURL)
        }
        
        if let jsonURL = DataExporter.exportToJSON(context: context) {
            items.append(jsonURL)
        }
        
        return items
    }
}
