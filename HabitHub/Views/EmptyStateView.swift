//
//  EmptyStateView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct EmptyStateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddHabit = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.badge.xmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(LocalizedKeys.noHabitsYet.localized)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(LocalizedKeys.addFirstHabit.localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAddHabit = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text(LocalizedKeys.addHabit.localized)
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(context: viewContext)
        }
    }
}

#Preview {
    EmptyStateView()
}
