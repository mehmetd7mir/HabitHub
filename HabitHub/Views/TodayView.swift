//
//  TodayView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HabitLogViewModel
    
    init(context: NSManagedObjectContext) {
        self._viewModel = StateObject(wrappedValue: HabitLogViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Header
                if !viewModel.todayHabits.isEmpty {
                    ProgressHeaderView(
                        completed: viewModel.completedCount,
                        total: viewModel.totalCount,
                        progress: viewModel.todayProgress
                    )
                    .padding()
                    .background(Color(.systemGray6))
                }
                
                // Habits List
                if viewModel.todayHabits.isEmpty {
                    EmptyTodayView()
                } else {
                    List {
                        ForEach(viewModel.todayHabits) { habitWithLog in
                            TodayHabitRowView(habitWithLog: habitWithLog) {
                                viewModel.toggleHabitCompletion(habitWithLog)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .subtleGradientBackground()
            .navigationTitle(LocalizedKeys.today.localized)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadTodayHabits()
            }
        }
    }
}

struct ProgressHeaderView: View {
    let completed: Int
    let total: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LocalizedKeys.todayProgress.localized)
                    .font(.headline)
                Spacer()
                Text("\(completed)/\(total)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Text("\(Int(progress * 100))% \(LocalizedKeys.completed.localized)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct TodayHabitRowView: View {
    let habitWithLog: HabitWithLog
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                Haptics.lightImpact()
                onToggle()
            }) {
                Image(systemName: habitWithLog.log.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(habitWithLog.log.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel(Text(habitWithLog.log.isCompleted ? LocalizedKeys.completedLabel.localized : LocalizedKeys.completed.localized))
            .accessibilityHint(Text("\(habitWithLog.habit.name ?? "")"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habitWithLog.habit.name ?? "Unknown")
                    .font(.headline)
                    .strikethrough(habitWithLog.log.isCompleted)
                
                Text("Hedef: \(habitWithLog.habit.targetDays) gün")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture { onToggle() }
    }
}

struct EmptyTodayView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Bugün için alışkanlık yok")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Aktif alışkanlıklarınız burada görünecek")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    return TodayView(context: ctx)
        .environment(\.managedObjectContext, ctx)
}
