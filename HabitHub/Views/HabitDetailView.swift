//
//  HabitDetailView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct HabitDetailView: View {
    let habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @State private var stats: HabitStats?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HabitHeaderView(habit: habit)
                    
                    // Stats Cards
                    if let stats = stats {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCardView(
                                title: LocalizedKeys.currentStreak.localized,
                                value: "\(stats.currentStreak)",
                                subtitle: LocalizedKeys.days.localized,
                                color: .green
                            )
                            
                            StatCardView(
                                title: LocalizedKeys.longestStreak.localized,
                                value: "\(stats.longestStreak)",
                                subtitle: LocalizedKeys.days.localized,
                                color: .blue
                            )
                            
                            StatCardView(
                                title: LocalizedKeys.completionRate.localized,
                                value: "\(Int(stats.completionRate * 100))",
                                subtitle: "%",
                                color: .orange
                            )
                            
                            StatCardView(
                                title: LocalizedKeys.totalDays.localized,
                                value: "\(stats.completedDays)",
                                subtitle: "/ \(stats.totalDays)",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                        
                        // Progress Chart
                        ProgressChartView(habit: habit, stats: stats)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle(habit.name ?? LocalizedKeys.habits.localized)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadStats()
            }
        }
    }
    
    private func loadStats() {
        let currentStreak = StreakCalculator.calculateCurrentStreak(for: habit, context: viewContext)
        let longestStreak = StreakCalculator.calculateLongestStreak(for: habit, context: viewContext)
        let completionRate = StreakCalculator.calculateCompletionRate(for: habit, context: viewContext)
        
        let totalDays = 30 // Last 30 days
        let completedDays = Int(completionRate * Double(totalDays))
        
        stats = HabitStats(
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            completionRate: completionRate,
            totalDays: totalDays,
            completedDays: completedDays
        )
    }
}

struct HabitHeaderView: View {
    let habit: Habit
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(habit.isActive ? .green : .gray)
            
            Text(habit.name ?? "Unknown")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(LocalizedKeys.targetDays.localized): \(habit.targetDays) \(LocalizedKeys.days.localized)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Circle()
                    .fill(habit.isActive ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                
                Text(habit.isActive ? LocalizedKeys.active.localized : LocalizedKeys.inactive.localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProgressChartView: View {
    let habit: Habit
    let stats: HabitStats
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(LocalizedKeys.totalDays.localized) 30")
                .font(.headline)
            
            HStack(spacing: 2) {
                ForEach(0..<30, id: \.self) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -29 + day, to: Date()) ?? Date()
                    let isCompleted = isHabitCompletedOnDate(date: date)
                    
                    Rectangle()
                        .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 20)
                        .cornerRadius(2)
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .cornerRadius(2)
                    Text(LocalizedKeys.completedLabel.localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .cornerRadius(2)
                    Text("\(LocalizedKeys.completed.localized) değil")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func isHabitCompletedOnDate(date: Date) -> Bool {
        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        request.predicate = NSPredicate(format: "habit == %@ AND date == %@", habit, Calendar.current.startOfDay(for: date) as NSDate)
        request.fetchLimit = 1
        do {
            let logs = try viewContext.fetch(request)
            return logs.first?.isCompleted ?? false
        } catch {
            return false
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let habit = Habit(context: context)
    habit.name = "Morning Exercise"
    habit.targetDays = 30
    habit.isActive = true
    
    return HabitDetailView(habit: habit)
        .environment(\.managedObjectContext, context)
}
