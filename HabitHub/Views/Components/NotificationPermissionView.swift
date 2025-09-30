//
//  NotificationPermissionView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI

struct NotificationPermissionView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showingPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text(LocalizedKeys.notificationPermission.localized)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(LocalizedKeys.notificationPermissionMessage.localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                Button(action: {
                    notificationManager.requestPermission()
                }) {
                    HStack {
                        Image(systemName: "bell")
                        Text(LocalizedKeys.allowNotifications.localized)
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    // Dismiss without permission
                }) {
                    Text(LocalizedKeys.later.localized)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .onChange(of: notificationManager.isAuthorized) { isAuthorized in
            if isAuthorized {
                // Permission granted, dismiss view
            }
        }
    }
}

#Preview {
    NotificationPermissionView()
}
