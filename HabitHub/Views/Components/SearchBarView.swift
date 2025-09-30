//
//  SearchBarView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var filterOption: FilterOption
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField(LocalizedKeys.searchHabits.localized, text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Filter Options
            HStack(spacing: 12) {
                FilterButton(
                    title: LocalizedKeys.all.localized,
                    isSelected: filterOption == .all,
                    action: { filterOption = .all }
                )
                
                FilterButton(
                    title: LocalizedKeys.active.localized,
                    isSelected: filterOption == .active,
                    action: { filterOption = .active }
                )
                
                FilterButton(
                    title: LocalizedKeys.inactive.localized,
                    isSelected: filterOption == .inactive,
                    action: { filterOption = .inactive }
                )
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

enum FilterOption: CaseIterable {
    case all
    case active
    case inactive
    
    var title: String {
        switch self {
        case .all: return "Tümü"
        case .active: return "Aktif"
        case .inactive: return "Pasif"
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

#Preview {
    @State var searchText = ""
    @State var filterOption = FilterOption.all
    
    return SearchBarView(searchText: $searchText, filterOption: $filterOption)
        .padding()
}
