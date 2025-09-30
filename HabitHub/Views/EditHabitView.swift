//
//  EditHabitView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct EditHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
    @State private var name: String
    @State private var targetDays: Int
    @State private var isActive: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(habit: Habit) {
        self.habit = habit
        self._name = State(initialValue: habit.name ?? "")
        self._targetDays = State(initialValue: Int(habit.targetDays))
        self._isActive = State(initialValue: habit.isActive)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedKeys.habitInfo.localized)) {
                    TextField(LocalizedKeys.habitName.localized, text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityLabel(Text(LocalizedKeys.habitName.localized))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(LocalizedKeys.targetDays.localized): \(targetDays)")
                            .font(.subheadline)
                        
                        Stepper(value: $targetDays, in: 1...365) {
                            Text(LocalizedKeys.days.localized)
                        }
                        .accessibilityLabel(Text(LocalizedKeys.targetDays.localized))
                    }
                    
                    Toggle(LocalizedKeys.active.localized, isOn: $isActive)
                        .accessibilityLabel(Text(LocalizedKeys.active.localized))
                }
                
                Section {
                    Button(action: {
                        if saveChanges() {
                            dismiss()
                        } else {
                            Haptics.error()
                            alertMessage = LocalizedKeys.enterValidInfo.localized
                            showingAlert = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(LocalizedKeys.update.localized)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? .white : .gray)
                    .listRowBackground(isFormValid ? Color.accentColor : Color.gray.opacity(0.3))
                }
            }
            .navigationTitle(LocalizedKeys.editHabit.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedKeys.cancel.localized) {
                        dismiss()
                    }
                }
            }
            .alert(LocalizedKeys.error.localized, isPresented: $showingAlert) {
                Button(LocalizedKeys.done.localized) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               name.count >= 3 &&
               targetDays >= 1 &&
               targetDays <= 365
    }
    
    private func saveChanges() -> Bool {
        // Validation
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        guard name.count >= 3 else {
            return false
        }
        
        guard targetDays >= 1 && targetDays <= 365 else {
            return false
        }
        
        // Update habit
        habit.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        habit.targetDays = Int32(targetDays)
        habit.isActive = isActive
        
        do {
            try viewContext.save()
            Haptics.success()
            return true
        } catch {
            print("Error updating habit: \(error)")
            Haptics.error()
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
    
    return EditHabitView(habit: habit)
        .environment(\.managedObjectContext, context)
}
