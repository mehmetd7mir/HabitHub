//
//  TodayViewNew.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct TodayViewNew: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HabitLogViewModel
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showingNotificationPermission = false
    
    init(context: NSManagedObjectContext) {
        self._viewModel = StateObject(wrappedValue: HabitLogViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Header
                if !viewModel.todayHabits.isEmpty {
                    ProgressHeaderViewNew(
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
                            TodayHabitRowViewNew(habitWithLog: habitWithLog) {
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
                checkNotificationPermission()
            }
            .sheet(isPresented: $showingNotificationPermission) {
                NotificationPermissionView()
            }
        }
    }
    
    private func checkNotificationPermission() {
        if !notificationManager.isAuthorized {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showingNotificationPermission = true
            }
        }
    }
}

struct ProgressHeaderViewNew: View {
    let completed: Int
    let total: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedKeys.todayProgress.localized)
                        .font(.headline)
                    
                    Text("\(completed)/\(total) \(LocalizedKeys.completed.localized)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    
                    Text(LocalizedKeys.completed.localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            // Motivational message
            if progress >= 1.0 {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Harika! Bugün tüm alışkanlıklarınızı tamamladınız! 🎉")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else if progress >= 0.8 {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("Çok iyi gidiyorsunuz! Devam edin! 🔥")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else if progress >= 0.5 {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.green)
                    Text("İyi gidiyorsunuz! Yarı yoldasınız! 👍")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct TodayHabitRowViewNew: View {
    let habitWithLog: HabitWithLog
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(habitColor)
                    .frame(width: 40, height: 40)
                
                Image(systemName: habitIconName)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(habitWithLog.habit.name ?? "Unknown")
                    .font(.headline)
                    .strikethrough(habitWithLog.log.isCompleted)
                    .foregroundColor(habitWithLog.log.isCompleted ? .secondary : .primary)
                
                Text("\(LocalizedKeys.targetDays.localized): \(habitWithLog.habit.targetDays) \(LocalizedKeys.days.localized)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Toggle Button
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
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture { onToggle() }
    }
    
    private var habitColor: Color {
        if let colorHex = habitWithLog.habit.colorHex {
            return Color(hex: colorHex) ?? .accentColor
        }
        return .accentColor
    }
    
    private var habitIconName: String {
        return habitWithLog.habit.iconName ?? "star.fill"
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    return TodayViewNew(context: ctx)
        .environment(\.managedObjectContext, ctx)
}
