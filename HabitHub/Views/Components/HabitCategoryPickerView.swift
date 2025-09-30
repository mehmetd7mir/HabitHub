//
//  HabitCategoryPickerView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct HabitCategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: HabitCategory?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(HabitCategory.allCases, id: \.id) { category in
                    CategoryRowView(category: category, isSelected: selectedCategory?.id == category.id) {
                        selectedCategory = category
                        dismiss()
                    }
                }
            }
            .navigationTitle(LocalizedKeys.category.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKeys.cancel.localized) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryRowView: View {
    let category: HabitCategory
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(category.color)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: category.iconName)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.localizedName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(category.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @State var selectedCategory: HabitCategory? = nil
    return HabitCategoryPickerView(selectedCategory: $selectedCategory)
}
