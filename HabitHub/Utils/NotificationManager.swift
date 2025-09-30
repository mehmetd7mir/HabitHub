//
//  NotificationManager.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import UserNotifications
import UIKit
import Combine

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
            
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleHabitReminder(for habit: Habit) {
        guard let reminderTime = habit.reminderTime,
              let habitName = habit.name else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Time for your habit: \(habitName)"
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "habit_\(habit.id?.uuidString ?? UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelHabitReminder(for habit: Habit) {
        let identifier = "habit_\(habit.id?.uuidString ?? UUID().uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func scheduleMotivationalNotification() {
        let motivationalMessages = [
            "Great job on your habits today! Keep it up! 🎉",
            "You're building amazing habits! Don't stop now! 💪",
            "Every small step counts! You're doing great! ⭐",
            "Consistency is key! You're on the right track! 🚀",
            "Your future self will thank you! Keep going! 🌟"
        ]
        
        let randomMessage = motivationalMessages.randomElement() ?? motivationalMessages[0]
        
        let content = UNMutableNotificationContent()
        content.title = "HabitHub"
        content.body = randomMessage
        content.sound = .default
        
        // Schedule for tomorrow at 9 AM
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        var triggerComponents = components
        triggerComponents.hour = 9
        triggerComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "motivational_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling motivational notification: \(error)")
            }
        }
    }
}
