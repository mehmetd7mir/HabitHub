//
//  ContentView.swift
//  HabitHub
//
//  Created by Mehmet  Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            HabitListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(LocalizedKeys.habits.localized)
                }
            
            TodayView(context: viewContext)
                .tabItem {
                    Image(systemName: "calendar")
                    Text(LocalizedKeys.today.localized)
                }
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text(LocalizedKeys.stats.localized)
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Ayarlar")
                }
        }
    }
}

#Preview {
    ContentView()
}
