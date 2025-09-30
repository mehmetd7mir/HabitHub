//
//  AddHabitView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct AddHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: HabitViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(context: NSManagedObjectContext) {
        self._viewModel = StateObject(wrappedValue: HabitViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView {
            Form {
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
                
                Section {
                    Button(action: {
                        if viewModel.saveHabit() {
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
        }
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    return AddHabitView(context: ctx)
        .environment(\.managedObjectContext, ctx)
}
