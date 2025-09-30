//
//  HabitCategory.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation
import SwiftUI

struct HabitCategory: Identifiable, CaseIterable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
    
    static let allCases: [HabitCategory] = [
        HabitCategory(name: "Health & Fitness", iconName: "heart.fill", color: .red),
        HabitCategory(name: "Learning", iconName: "book.fill", color: .blue),
        HabitCategory(name: "Productivity", iconName: "checkmark.circle.fill", color: .green),
        HabitCategory(name: "Mindfulness", iconName: "leaf.fill", color: .mint),
        HabitCategory(name: "Social", iconName: "person.2.fill", color: .orange),
        HabitCategory(name: "Creative", iconName: "paintbrush.fill", color: .purple),
        HabitCategory(name: "Financial", iconName: "dollarsign.circle.fill", color: .yellow),
        HabitCategory(name: "Home", iconName: "house.fill", color: .brown),
        HabitCategory(name: "Other", iconName: "star.fill", color: .gray)
    ]
    
    var localizedName: String {
        switch name {
        case "Health & Fitness": return "Sağlık & Fitness"
        case "Learning": return "Öğrenme"
        case "Productivity": return "Verimlilik"
        case "Mindfulness": return "Farkındalık"
        case "Social": return "Sosyal"
        case "Creative": return "Yaratıcılık"
        case "Financial": return "Finansal"
        case "Home": return "Ev"
        case "Other": return "Diğer"
        default: return name
        }
    }
}

struct HabitIcon: Identifiable, CaseIterable {
    let id = UUID()
    let name: String
    let category: String
    
    static let allCases: [HabitIcon] = [
        // Health & Fitness
        HabitIcon(name: "heart.fill", category: "Health & Fitness"),
        HabitIcon(name: "figure.run", category: "Health & Fitness"),
        HabitIcon(name: "dumbbell.fill", category: "Health & Fitness"),
        HabitIcon(name: "bicycle", category: "Health & Fitness"),
        HabitIcon(name: "figure.walk", category: "Health & Fitness"),
        HabitIcon(name: "figure.yoga", category: "Health & Fitness"),
        HabitIcon(name: "drop.fill", category: "Health & Fitness"),
        HabitIcon(name: "bed.double.fill", category: "Health & Fitness"),
        
        // Learning
        HabitIcon(name: "book.fill", category: "Learning"),
        HabitIcon(name: "graduationcap.fill", category: "Learning"),
        HabitIcon(name: "pencil", category: "Learning"),
        HabitIcon(name: "brain.head.profile", category: "Learning"),
        HabitIcon(name: "lightbulb.fill", category: "Learning"),
        HabitIcon(name: "magnifyingglass", category: "Learning"),
        
        // Productivity
        HabitIcon(name: "checkmark.circle.fill", category: "Productivity"),
        HabitIcon(name: "clock.fill", category: "Productivity"),
        HabitIcon(name: "calendar", category: "Productivity"),
        HabitIcon(name: "list.bullet", category: "Productivity"),
        HabitIcon(name: "target", category: "Productivity"),
        HabitIcon(name: "chart.line.uptrend.xyaxis", category: "Productivity"),
        
        // Mindfulness
        HabitIcon(name: "leaf.fill", category: "Mindfulness"),
        HabitIcon(name: "moon.fill", category: "Mindfulness"),
        HabitIcon(name: "sun.max.fill", category: "Mindfulness"),
        HabitIcon(name: "cloud.fill", category: "Mindfulness"),
        HabitIcon(name: "tree.fill", category: "Mindfulness"),
        HabitIcon(name: "wind", category: "Mindfulness"),
        
        // Social
        HabitIcon(name: "person.2.fill", category: "Social"),
        HabitIcon(name: "person.fill", category: "Social"),
        HabitIcon(name: "message.fill", category: "Social"),
        HabitIcon(name: "phone.fill", category: "Social"),
        HabitIcon(name: "envelope.fill", category: "Social"),
        HabitIcon(name: "hand.raised.fill", category: "Social"),
        
        // Creative
        HabitIcon(name: "paintbrush.fill", category: "Creative"),
        HabitIcon(name: "music.note", category: "Creative"),
        HabitIcon(name: "camera.fill", category: "Creative"),
        HabitIcon(name: "pencil.and.outline", category: "Creative"),
        HabitIcon(name: "theatermasks.fill", category: "Creative"),
        HabitIcon(name: "paintpalette.fill", category: "Creative"),
        
        // Financial
        HabitIcon(name: "dollarsign.circle.fill", category: "Financial"),
        HabitIcon(name: "creditcard.fill", category: "Financial"),
        HabitIcon(name: "banknote.fill", category: "Financial"),
        HabitIcon(name: "chart.pie.fill", category: "Financial"),
        HabitIcon(name: "building.2.fill", category: "Financial"),
        
        // Home
        HabitIcon(name: "house.fill", category: "Home"),
        HabitIcon(name: "wrench.and.screwdriver.fill", category: "Home"),
        HabitIcon(name: "car.fill", category: "Home"),
        HabitIcon(name: "fork.knife", category: "Home"),
        HabitIcon(name: "washer.fill", category: "Home"),
        HabitIcon(name: "broom.fill", category: "Home"),
        
        // Other
        HabitIcon(name: "star.fill", category: "Other"),
        HabitIcon(name: "heart.fill", category: "Other"),
        HabitIcon(name: "sparkles", category: "Other"),
        HabitIcon(name: "gift.fill", category: "Other"),
        HabitIcon(name: "gamecontroller.fill", category: "Other"),
        HabitIcon(name: "tv.fill", category: "Other")
    ]
    
    static func icons(for category: String) -> [HabitIcon] {
        return allCases.filter { $0.category == category }
    }
}

struct HabitColor: Identifiable, CaseIterable {
    let id = UUID()
    let name: String
    let color: Color
    let hex: String
    
    static let allCases: [HabitColor] = [
        HabitColor(name: "Red", color: .red, hex: "#FF3B30"),
        HabitColor(name: "Orange", color: .orange, hex: "#FF9500"),
        HabitColor(name: "Yellow", color: .yellow, hex: "#FFCC00"),
        HabitColor(name: "Green", color: .green, hex: "#34C759"),
        HabitColor(name: "Mint", color: .mint, hex: "#00C7BE"),
        HabitColor(name: "Teal", color: .teal, hex: "#30B0C7"),
        HabitColor(name: "Cyan", color: .cyan, hex: "#32D74B"),
        HabitColor(name: "Blue", color: .blue, hex: "#007AFF"),
        HabitColor(name: "Indigo", color: .indigo, hex: "#5856D6"),
        HabitColor(name: "Purple", color: .purple, hex: "#AF52DE"),
        HabitColor(name: "Pink", color: .pink, hex: "#FF2D92"),
        HabitColor(name: "Brown", color: .brown, hex: "#A2845E"),
        HabitColor(name: "Gray", color: .gray, hex: "#8E8E93")
    ]
}
