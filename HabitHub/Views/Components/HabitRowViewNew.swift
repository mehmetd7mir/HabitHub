//
//  HabitRowViewNew.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct HabitRowViewNew: View {
    let habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentStreak: Int = 0
    @State private var completionRate: Double = 0.0
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(habitColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: habitIconName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name ?? "Unknown")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("\(LocalizedKeys.streak.localized): \(currentStreak)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(completionRate * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Progress Bar
                ProgressView(value: completionRate)
                    .progressViewStyle(LinearProgressViewStyle(tint: habitColor))
                    .scaleEffect(x: 1, y: 0.5, anchor: .center)
            }
            
            // Status
            VStack(alignment: .trailing, spacing: 4) {
                Circle()
                    .fill(habit.isActive ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                
                Text(habit.isActive ? LocalizedKeys.active.localized : LocalizedKeys.inactive.localized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text((habit.name ?? "") + ", " + LocalizedKeys.streak.localized + ": \(currentStreak)"))
        .onAppear {
            loadHabitData()
        }
    }
    
    private var habitColor: Color {
        if let colorHex = habit.colorHex {
            return Color(hex: colorHex) ?? .accentColor
        }
        return .accentColor
    }
    
    private var habitIconName: String {
        return habit.iconName ?? "star.fill"
    }
    
    private func loadHabitData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let streak = StreakCalculator.calculateCurrentStreak(for: habit, context: viewContext)
            let rate = StreakCalculator.calculateCompletionRate(for: habit, context: viewContext)
            
            DispatchQueue.main.async {
                self.currentStreak = streak
                self.completionRate = rate
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let habit = Habit(context: context)
    habit.name = "Morning Exercise"
    habit.targetDays = 30
    habit.isActive = true
    habit.iconName = "figure.run"
    habit.colorHex = "#FF3B30"
    
    return HabitRowViewNew(habit: habit)
        .padding()
        .environment(\.managedObjectContext, context)
}
