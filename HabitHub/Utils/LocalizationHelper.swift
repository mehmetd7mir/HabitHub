//
//  LocalizationHelper.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// MARK: - Localized Keys
struct LocalizedKeys {
    // Navigation
    static let habits = "habits"
    static let today = "today"
    static let stats = "stats"
    
    // Common
    static let save = "save"
    static let cancel = "cancel"
    static let delete = "delete"
    static let edit = "edit"
    static let add = "add"
    static let close = "close"
    static let done = "done"
    static let yes = "yes"
    static let no = "no"
    
    // Habits
    static let myHabits = "my_habits"
    static let addHabit = "add_habit"
    static let newHabit = "new_habit"
    static let editHabit = "edit_habit"
    static let deleteHabit = "delete_habit"
    static let habitName = "habit_name"
    static let targetDays = "target_days"
    static let days = "days"
    static let active = "active"
    static let inactive = "inactive"
    static let streak = "streak"
    
    // Today
    static let todayProgress = "today_progress"
    static let completed = "completed"
    static let noHabitsToday = "no_habits_today"
    static let activeHabitsHere = "active_habits_here"
    static let completedLabel = "completed_label"
    
    // Stats
    static let statistics = "statistics"
    static let overallProgress = "overall_progress"
    static let weeklyProgress = "weekly_progress"
    static let habitPerformance = "habit_performance"
    static let totalHabits = "total_habits"
    static let activeHabits = "active_habits"
    static let completedDays = "completed_days"
    static let averageRate = "average_rate"
    static let currentStreak = "current_streak"
    static let longestStreak = "longest_streak"
    static let completionRate = "completion_rate"
    static let totalDays = "total_days"
    
    // Empty States
    static let noHabitsYet = "no_habits_yet"
    static let addFirstHabit = "add_first_habit"
    static let noSearchResults = "no_search_results"
    static let tryDifferentKeywords = "try_different_keywords"
    
    // Search & Filter
    static let searchHabits = "search_habits"
    static let all = "all"
    static let filter = "filter"
    
    // Alerts
    static let error = "error"
    static let enterValidInfo = "enter_valid_info"
    static let deleteConfirmation = "delete_confirmation"
    static let loadingStats = "loading_stats"
    
    // Form Validation
    static let nameRequired = "name_required"
    static let nameMinLength = "name_min_length"
    static let targetDaysRange = "target_days_range"

    // Forms/Sections
    static let habitInfo = "habit_info"

    // Settings
    static let settings = "settings"
    static let dataManagement = "data_management"
    static let exportData = "export_data"
    static let createBackup = "create_backup"
    static let appInfo = "app_info"
    static let version = "version"
    static let developer = "developer"
    static let support = "support"
    static let help = "help"
    static let feedback = "feedback"
    static let info = "info"
    static let noDataToExport = "no_data_to_export"
    static let backupCreated = "backup_created"
    static let backupFailed = "backup_failed"
    static let jsonImport = "json_import"
    static let importSuccess = "import_success"
    static let importFailed = "import_failed"
}
