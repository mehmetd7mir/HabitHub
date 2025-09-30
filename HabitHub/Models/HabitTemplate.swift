//
//  HabitTemplate.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation

struct HabitTemplate: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let iconName: String
    let colorHex: String
    let description: String
    let targetDays: Int32
    let frequency: String
    let reminderTime: Date?
    
    static let allTemplates: [HabitTemplate] = [
        // Health & Fitness
        HabitTemplate(
            name: "Morning Exercise",
            category: "Health & Fitness",
            iconName: "figure.run",
            colorHex: "#FF3B30",
            description: "Start your day with physical activity",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 7, minute: 0))
        ),
        HabitTemplate(
            name: "Drink Water",
            category: "Health & Fitness",
            iconName: "drop.fill",
            colorHex: "#007AFF",
            description: "Stay hydrated throughout the day",
            targetDays: 30,
            frequency: "daily",
            reminderTime: nil
        ),
        HabitTemplate(
            name: "Get 8 Hours Sleep",
            category: "Health & Fitness",
            iconName: "bed.double.fill",
            colorHex: "#5856D6",
            description: "Maintain a healthy sleep schedule",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 22, minute: 0))
        ),
        HabitTemplate(
            name: "Meditation",
            category: "Mindfulness",
            iconName: "leaf.fill",
            colorHex: "#34C759",
            description: "Practice mindfulness and meditation",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 8, minute: 0))
        ),
        
        // Learning
        HabitTemplate(
            name: "Read Books",
            category: "Learning",
            iconName: "book.fill",
            colorHex: "#FF9500",
            description: "Read for at least 30 minutes daily",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 20, minute: 0))
        ),
        HabitTemplate(
            name: "Learn New Language",
            category: "Learning",
            iconName: "graduationcap.fill",
            colorHex: "#AF52DE",
            description: "Practice a new language daily",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 19, minute: 0))
        ),
        
        // Productivity
        HabitTemplate(
            name: "Plan Your Day",
            category: "Productivity",
            iconName: "list.bullet",
            colorHex: "#FFCC00",
            description: "Plan your tasks and goals for the day",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 8, minute: 30))
        ),
        HabitTemplate(
            name: "No Social Media",
            category: "Productivity",
            iconName: "iphone",
            colorHex: "#8E8E93",
            description: "Avoid social media during work hours",
            targetDays: 30,
            frequency: "daily",
            reminderTime: nil
        ),
        
        // Creative
        HabitTemplate(
            name: "Write Journal",
            category: "Creative",
            iconName: "pencil",
            colorHex: "#00C7BE",
            description: "Write in your journal daily",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 21, minute: 0))
        ),
        HabitTemplate(
            name: "Practice Music",
            category: "Creative",
            iconName: "music.note",
            colorHex: "#FF2D92",
            description: "Practice your musical instrument",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 18, minute: 0))
        ),
        
        // Social
        HabitTemplate(
            name: "Call Family",
            category: "Social",
            iconName: "phone.fill",
            colorHex: "#A2845E",
            description: "Stay connected with family members",
            targetDays: 30,
            frequency: "weekly",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 19, minute: 0))
        ),
        HabitTemplate(
            name: "Meet Friends",
            category: "Social",
            iconName: "person.2.fill",
            colorHex: "#30B0C7",
            description: "Spend quality time with friends",
            targetDays: 30,
            frequency: "weekly",
            reminderTime: nil
        ),
        
        // Financial
        HabitTemplate(
            name: "Track Expenses",
            category: "Financial",
            iconName: "dollarsign.circle.fill",
            colorHex: "#34C759",
            description: "Keep track of your daily expenses",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 22, minute: 0))
        ),
        HabitTemplate(
            name: "Save Money",
            category: "Financial",
            iconName: "banknote.fill",
            colorHex: "#FFCC00",
            description: "Save a small amount daily",
            targetDays: 30,
            frequency: "daily",
            reminderTime: nil
        ),
        
        // Home
        HabitTemplate(
            name: "Clean Room",
            category: "Home",
            iconName: "broom.fill",
            colorHex: "#8E8E93",
            description: "Keep your living space tidy",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 20, minute: 0))
        ),
        HabitTemplate(
            name: "Cook Healthy Meals",
            category: "Home",
            iconName: "fork.knife",
            colorHex: "#FF9500",
            description: "Prepare healthy meals at home",
            targetDays: 30,
            frequency: "daily",
            reminderTime: Calendar.current.date(from: DateComponents(hour: 18, minute: 0))
        )
    ]
    
    static func templates(for category: String) -> [HabitTemplate] {
        return allTemplates.filter { $0.category == category }
    }
}
