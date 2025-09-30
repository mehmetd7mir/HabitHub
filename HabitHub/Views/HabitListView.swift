//
//  HabitListView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdDate, ascending: false)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @State private var showingAddHabit = false
    @State private var showingEditHabit = false
    @State private var showingDetailView = false
    @State private var selectedHabit: Habit?
    @State private var showingDeleteAlert = false
    @State private var habitToDelete: Habit?
    
    @State private var searchText = ""
    @State private var filterOption: FilterOption = .all
    
    var filteredHabits: [Habit] {
        let filtered = habits.filter { habit in
            // Search filter
            let matchesSearch = searchText.isEmpty || 
                (habit.name?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            // Status filter
            let matchesFilter: Bool
            switch filterOption {
            case .all:
                matchesFilter = true
            case .active:
                matchesFilter = habit.isActive
            case .inactive:
                matchesFilter = !habit.isActive
            }
            
            return matchesSearch && matchesFilter
        }
        
        return Array(filtered)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                SearchBarView(searchText: $searchText, filterOption: $filterOption)
                    .padding(.vertical, 8)
                
                if filteredHabits.isEmpty {
                    if habits.isEmpty {
                        EmptyStateView()
                    } else {
                        EmptySearchView()
                    }
                } else {
                    List {
                        ForEach(filteredHabits, id: \.id) { habit in
                            HabitRowViewNew(habit: habit)
                                .onTapGesture {
                                    selectedHabit = habit
                                    showingDetailView = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(LocalizedKeys.delete.localized, role: .destructive) {
                                        habitToDelete = habit
                                        showingDeleteAlert = true
                                    }
                                    
                                    Button(LocalizedKeys.edit.localized) {
                                        selectedHabit = habit
                                        showingEditHabit = true
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                }
            }
            .subtleGradientBackground()
            .navigationTitle(LocalizedKeys.myHabits.localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitViewNew(context: viewContext)
            }
            .sheet(isPresented: $showingEditHabit) {
                if let habit = selectedHabit {
                    EditHabitView(habit: habit)
                }
            }
            .sheet(isPresented: $showingDetailView) {
                if let habit = selectedHabit {
                    HabitDetailView(habit: habit)
                }
            }
            .alert(LocalizedKeys.deleteHabit.localized, isPresented: $showingDeleteAlert) {
                Button(LocalizedKeys.cancel.localized, role: .cancel) { }
                Button(LocalizedKeys.delete.localized, role: .destructive) {
                    if let habit = habitToDelete {
                        deleteHabit(habit)
                    }
                }
            } message: {
                Text(LocalizedKeys.deleteConfirmation.localized)
            }
        }
    }
    
    private func deleteHabit(_ habit: Habit) {
        viewContext.delete(habit)
        
        do {
            try viewContext.save()
            Haptics.success()
        } catch {
            print("Error deleting habit: \(error)")
            Haptics.error()
        }
    }
}

#Preview {
    HabitListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
