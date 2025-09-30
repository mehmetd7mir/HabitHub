//
//  HabitColorPickerView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct HabitColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColor: HabitColor?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(HabitColor.allCases, id: \.id) { color in
                        ColorButtonView(color: color, isSelected: selectedColor?.id == color.id) {
                            selectedColor = color
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizedKeys.color.localized)
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

struct ColorButtonView: View {
    let color: HabitColor
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.color)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .shadow(color: .black, radius: 1)
                    }
                }
                
                Text(color.name)
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @State var selectedColor: HabitColor? = nil
    return HabitColorPickerView(selectedColor: $selectedColor)
}
