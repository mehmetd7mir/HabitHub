//
//  HabitFrequency.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import Foundation

enum HabitFrequency: String, CaseIterable, Identifiable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case custom = "custom"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .daily: return "Günlük"
        case .weekly: return "Haftalık"
        case .monthly: return "Aylık"
        case .custom: return "Özel"
        }
    }
    
    var localizedName: String {
        switch self {
        case .daily: return "Günlük"
        case .weekly: return "Haftalık"
        case .monthly: return "Aylık"
        case .custom: return "Özel"
        }
    }
    
    var description: String {
        switch self {
        case .daily: return "Her gün"
        case .weekly: return "Haftada bir"
        case .monthly: return "Ayda bir"
        case .custom: return "Özel aralık"
        }
    }
}
