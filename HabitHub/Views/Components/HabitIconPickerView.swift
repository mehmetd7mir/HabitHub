//
//  HabitIconPickerView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct HabitIconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let category: String
    @Binding var selectedIcon: HabitIcon?
    
    private var icons: [HabitIcon] {
        HabitIcon.icons(for: category)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(icons, id: \.id) { icon in
                        IconButtonView(icon: icon, isSelected: selectedIcon?.id == icon.id) {
                            selectedIcon = icon
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizedKeys.icon.localized)
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

struct IconButtonView: View {
    let icon: HabitIcon
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color(.systemGray5))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon.name)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.caption)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @State var selectedIcon: HabitIcon? = nil
    return HabitIconPickerView(category: "Health & Fitness", selectedIcon: $selectedIcon)
}
