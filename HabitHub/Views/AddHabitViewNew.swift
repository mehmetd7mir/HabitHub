//
//  AddHabitViewNew.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct AddHabitViewNew: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: HabitViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingTemplatePicker = false
    @State private var showingCategoryPicker = false
    @State private var showingIconPicker = false
    @State private var showingColorPicker = false
    @State private var showingReminderPicker = false
    @State private var selectedCategory: HabitCategory?
    @State private var selectedIcon: HabitIcon?
    @State private var selectedColor: HabitColor?
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var reminderTime: Date = Date()
    @State private var hasReminder = false
    @State private var notes = ""
    
    init(context: NSManagedObjectContext) {
        self._viewModel = StateObject(wrappedValue: HabitViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Template Selection
                Section(header: Text(LocalizedKeys.templates.localized)) {
                    HStack {
                        Button(action: {
                            showingTemplatePicker = true
                        }) {
                            HStack {
                                Image(systemName: "doc.text")
                                Text(LocalizedKeys.chooseTemplate.localized)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                
                // Basic Info
                Section(header: Text(LocalizedKeys.habitInfo.localized)) {
                    TextField(LocalizedKeys.habitName.localized, text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityLabel(Text(LocalizedKeys.habitName.localized))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(LocalizedKeys.targetDays.localized): \(viewModel.targetDays)")
                            .font(.subheadline)
                        
                        Stepper(value: $viewModel.targetDays, in: 1...365) {
                            Text(LocalizedKeys.days.localized)
                        }
                        .accessibilityLabel(Text(LocalizedKeys.targetDays.localized))
                    }
                    
                    Toggle(LocalizedKeys.active.localized, isOn: $viewModel.isActive)
                        .accessibilityLabel(Text(LocalizedKeys.active.localized))
                }
                
                // Category & Icon
                Section(header: Text(LocalizedKeys.category.localized)) {
                    HStack {
                        Button(action: {
                            showingCategoryPicker = true
                        }) {
                            HStack {
                                if let category = selectedCategory {
                                    Image(systemName: category.iconName)
                                        .foregroundColor(category.color)
                                    Text(category.localizedName)
                                } else {
                                    Image(systemName: "folder")
                                    Text(LocalizedKeys.selectCategory.localized)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    if let category = selectedCategory {
                        HStack {
                            Button(action: {
                                showingIconPicker = true
                            }) {
                                HStack {
                                    if let icon = selectedIcon {
                                        Image(systemName: icon.name)
                                            .foregroundColor(selectedColor?.color ?? .accentColor)
                                    } else {
                                        Image(systemName: "star")
                                    }
                                    Text(LocalizedKeys.icon.localized)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                
                // Color
                if selectedIcon != nil {
                    Section(header: Text(LocalizedKeys.color.localized)) {
                        HStack {
                            Button(action: {
                                showingColorPicker = true
                            }) {
                                HStack {
                                    if let color = selectedColor {
                                        Circle()
                                            .fill(color.color)
                                            .frame(width: 20, height: 20)
                                        Text(color.name)
                                    } else {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 20, height: 20)
                                        Text(LocalizedKeys.selectColor.localized)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                
                // Frequency
                Section(header: Text(LocalizedKeys.frequency.localized)) {
                    Picker(LocalizedKeys.frequency.localized, selection: $selectedFrequency) {
                        ForEach(HabitFrequency.allCases) { frequency in
                            Text(frequency.localizedName).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Reminder
                Section(header: Text(LocalizedKeys.reminder.localized)) {
                    Toggle(LocalizedKeys.setReminder.localized, isOn: $hasReminder)
                    
                    if hasReminder {
                        DatePicker(LocalizedKeys.reminderTime.localized, selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                // Notes
                Section(header: Text(LocalizedKeys.notes.localized)) {
                    TextField(LocalizedKeys.notesPlaceholder.localized, text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                // Save Button
                Section {
                    Button(action: {
                        if saveHabit() {
                            Haptics.success()
                            dismiss()
                        } else {
                            Haptics.error()
                            alertMessage = LocalizedKeys.enterValidInfo.localized
                            showingAlert = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(LocalizedKeys.save.localized)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                    .foregroundColor(viewModel.isFormValid ? .white : .gray)
                    .listRowBackground(viewModel.isFormValid ? Color.accentColor : Color.gray.opacity(0.3))
                }
            }
            .navigationTitle(LocalizedKeys.newHabit.localized)
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
            .sheet(isPresented: $showingTemplatePicker) {
                HabitTemplatePickerView { template in
                    applyTemplate(template)
                }
            }
            .sheet(isPresented: $showingCategoryPicker) {
                HabitCategoryPickerView(selectedCategory: $selectedCategory)
            }
            .sheet(isPresented: $showingIconPicker) {
                if let category = selectedCategory {
                    HabitIconPickerView(category: category.name, selectedIcon: $selectedIcon)
                }
            }
            .sheet(isPresented: $showingColorPicker) {
                HabitColorPickerView(selectedColor: $selectedColor)
            }
        }
    }
    
    private func applyTemplate(_ template: HabitTemplate) {
        viewModel.name = template.name
        viewModel.targetDays = Int(template.targetDays)
        selectedCategory = HabitCategory.allCases.first { $0.name == template.category }
        selectedIcon = HabitIcon.allCases.first { $0.name == template.iconName }
        selectedColor = HabitColor.allCases.first { $0.hex == template.colorHex }
        selectedFrequency = HabitFrequency(rawValue: template.frequency) ?? .daily
        hasReminder = template.reminderTime != nil
        if let time = template.reminderTime {
            reminderTime = time
        }
    }
    
    private func saveHabit() -> Bool {
        // Validation
        let trimmedName = viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            print("Validation failed: Habit name is empty")
            return false
        }
        
        guard trimmedName.count >= 3 else {
            print("Validation failed: Habit name too short (\(trimmedName.count) characters)")
            return false
        }
        
        guard viewModel.targetDays >= 1 && viewModel.targetDays <= 365 else {
            print("Validation failed: Target days out of range (\(viewModel.targetDays))")
            return false
        }
        
        // Create new habit
        let habit = Habit(context: viewContext)
        habit.id = UUID()
        habit.name = trimmedName
        habit.createdDate = Date()
        habit.targetDays = Int32(viewModel.targetDays)
        habit.isActive = viewModel.isActive
        habit.category = selectedCategory?.name
        habit.iconName = selectedIcon?.name
        habit.colorHex = selectedColor?.hex
        habit.notes = notes.isEmpty ? nil : notes
        habit.frequency = selectedFrequency.rawValue
        habit.reminderTime = hasReminder ? reminderTime : nil
        
        do {
            try viewContext.save()
            
            // Schedule notification if reminder is set
            if hasReminder {
                NotificationManager.shared.scheduleHabitReminder(for: habit)
            }
            
            viewModel.resetForm()
            return true
        } catch {
            print("Error saving habit: \(error)")
            return false
        }
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    return AddHabitViewNew(context: ctx)
        .environment(\.managedObjectContext, ctx)
}
