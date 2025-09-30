//
//  StatsView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct StatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @State private var overallStats: OverallStats?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let stats = overallStats {
                        // Overall Progress
                        OverallProgressView(stats: stats)
                            .padding(.horizontal)
                        
                        // Weekly Progress
                        WeeklyProgressView(habits: Array(habits))
                            .padding(.horizontal)
                        
                        // Habit Performance
                        HabitPerformanceView(habits: Array(habits))
                            .padding(.horizontal)
                    } else {
                        ProgressView(LocalizedKeys.loadingStats.localized)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(.vertical)
            }
            .subtleGradientBackground()
            .navigationTitle(LocalizedKeys.statistics.localized)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadOverallStats()
            }
        }
    }
    
    private func loadOverallStats() {
        let activeHabits = habits.filter { $0.isActive }
        let totalHabits = habits.count
        
        var totalCompletedDays = 0
        var totalStreak = 0
        
        for habit in activeHabits {
            totalCompletedDays += Int(StreakCalculator.calculateCompletionRate(for: habit, context: viewContext) * 30)
            totalStreak += StreakCalculator.calculateCurrentStreak(for: habit, context: viewContext)
        }
        
        let averageCompletionRate = activeHabits.isEmpty ? 0.0 : 
            activeHabits.map { StreakCalculator.calculateCompletionRate(for: $0, context: viewContext) }.reduce(0, +) / Double(activeHabits.count)
        
        overallStats = OverallStats(
            totalHabits: totalHabits,
            activeHabits: activeHabits.count,
            totalCompletedDays: totalCompletedDays,
            averageCompletionRate: averageCompletionRate,
            totalStreak: totalStreak
        )
    }
}

struct OverallStats {
    let totalHabits: Int
    let activeHabits: Int
    let totalCompletedDays: Int
    let averageCompletionRate: Double
    let totalStreak: Int
}

struct OverallProgressView: View {
    let stats: OverallStats
    
    var body: some View {
        VStack(spacing: 16) {
            Text(LocalizedKeys.overallProgress.localized)
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCardView(
                    title: LocalizedKeys.totalHabits.localized,
                    value: "\(stats.totalHabits)",
                    subtitle: "",
                    color: .blue
                )
                
                StatCardView(
                    title: LocalizedKeys.activeHabits.localized,
                    value: "\(stats.activeHabits)",
                    subtitle: "",
                    color: .green
                )
                
                StatCardView(
                    title: LocalizedKeys.completedDays.localized,
                    value: "\(stats.totalCompletedDays)",
                    subtitle: LocalizedKeys.days.localized,
                    color: .orange
                )
                
                StatCardView(
                    title: LocalizedKeys.averageRate.localized,
                    value: "\(Int(stats.averageCompletionRate * 100))",
                    subtitle: "%",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct WeeklyProgressView: View {
    let habits: [Habit]
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedKeys.weeklyProgress.localized)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 2) {
                ForEach(0..<7, id: \.self) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date()) ?? Date()
                    let completionRate = getDayCompletionRate(date: date)
                    
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(completionRate > 0 ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 20, height: CGFloat(completionRate * 40))
                            .cornerRadius(4)
                        
                        Text(dayName(for: date))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 60)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func getDayCompletionRate(date: Date) -> Double {
        let activeHabits = habits.filter { $0.isActive }
        guard !activeHabits.isEmpty else { return 0.0 }
        
        var completedCount = 0
        for habit in activeHabits {
            if isHabitCompletedOnDate(habit: habit, date: date) {
                completedCount += 1
            }
        }
        
        return Double(completedCount) / Double(activeHabits.count)
    }
    
    private func isHabitCompletedOnDate(habit: Habit, date: Date) -> Bool {
        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        request.predicate = NSPredicate(format: "habit == %@ AND date == %@", habit, date as NSDate)
        request.fetchLimit = 1
        
        do {
            let logs = try viewContext.fetch(request)
            return logs.first?.isCompleted ?? false
        } catch {
            return false
        }
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct HabitPerformanceView: View {
    let habits: [Habit]
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedKeys.habitPerformance.localized)
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(habits.prefix(5), id: \.id) { habit in
                HabitPerformanceRowView(habit: habit)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct HabitPerformanceRowView: View {
    let habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @State private var completionRate: Double = 0.0
    @State private var currentStreak: Int = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name ?? "Unknown")
                    .font(.headline)
                
                Text("\(Int(completionRate * 100))% tamamlanma")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(currentStreak) gün")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                
                Text("streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            loadPerformanceData()
        }
    }
    
    private func loadPerformanceData() {
        completionRate = StreakCalculator.calculateCompletionRate(for: habit, context: viewContext)
        currentStreak = StreakCalculator.calculateCurrentStreak(for: habit, context: viewContext)
    }
}

#Preview {
    StatsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
