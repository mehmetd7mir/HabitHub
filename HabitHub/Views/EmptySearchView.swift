//
//  EmptySearchView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(LocalizedKeys.noSearchResults.localized)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(LocalizedKeys.tryDifferentKeywords.localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    EmptySearchView()
}
