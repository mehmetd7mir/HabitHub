//
//  GradientBackground.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import Combine

struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func subtleGradientBackground() -> some View {
        self.modifier(GradientBackground())
    }
}


