//
//  HabitRowView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct HabitRowView: View {
    let habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentStreak: Int = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name ?? "Unknown")
                    .font(.headline)
                
                Text("Hedef: \(habit.targetDays) gün")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Streak: \(currentStreak)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Circle()
                    .fill(habit.isActive ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text((habit.name ?? "") + ", " + LocalizedKeys.streak.localized + ": \(currentStreak)"))
        .onAppear {
            loadCurrentStreak()
        }
    }
    
    private func loadCurrentStreak() {
        currentStreak = StreakCalculator.calculateCurrentStreak(for: habit, context: viewContext)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let habit = Habit(context: context)
    habit.name = "Morning Exercise"
    habit.targetDays = 30
    habit.isActive = true
    
    return HabitRowView(habit: habit)
        .padding()
}
