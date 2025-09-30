//
//  HabitHubApp.swift
//  HabitHub
//
//  Created by Mehmet  Demir on 25.09.2025.
//

import SwiftUI
import CoreData

@main
struct HabitHubApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
