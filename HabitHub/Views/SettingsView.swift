//
//  SettingsView.swift
//  HabitHub
//
//  Created by Mehmet Demir on 25.09.2025.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(LocalizedKeys.dataManagement.localized)) {
                    Button(action: {
                        exportData()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                            Text(LocalizedKeys.exportData.localized)
                        }
                    }
                    
                    Button(action: {
                        createBackup()
                    }) {
                        HStack {
                            Image(systemName: "icloud.and.arrow.up")
                                .foregroundColor(.green)
                            Text(LocalizedKeys.createBackup.localized)
                        }
                    }

                    Button(action: {
                        importBackup()
                    }) {
                        HStack {
                            Image(systemName: "tray.and.arrow.down")
                                .foregroundColor(.blue)
                            Text(LocalizedKeys.jsonImport.localized)
                        }
                    }
                }
                
                Section(header: Text(LocalizedKeys.appInfo.localized)) {
                    HStack {
                        Text(LocalizedKeys.version.localized)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(LocalizedKeys.developer.localized)
                        Spacer()
                        Text("Mehmet Demir")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text(LocalizedKeys.support.localized)) {
                    Button(action: {
                        // TODO: Add support action
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.orange)
                            Text(LocalizedKeys.help.localized)
                        }
                    }
                    
                    Button(action: {
                        // TODO: Add feedback action
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.purple)
                            Text(LocalizedKeys.feedback.localized)
                        }
                    }
                }
            }
            .subtleGradientBackground()
            .navigationTitle(LocalizedKeys.settings.localized)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: shareItems)
            }
            .alert(LocalizedKeys.info.localized, isPresented: $showingAlert) {
                Button(LocalizedKeys.done.localized) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func exportData() {
        shareItems = BackupManager.shareBackup(context: viewContext)
        if shareItems.isEmpty {
            alertMessage = LocalizedKeys.noDataToExport.localized
            showingAlert = true
        } else {
            showingShareSheet = true
        }
    }
    
    private func createBackup() {
        if let _ = BackupManager.createBackup(context: viewContext) {
            alertMessage = LocalizedKeys.backupCreated.localized
            showingAlert = true
        } else {
            alertMessage = LocalizedKeys.backupFailed.localized
            showingAlert = true
        }
    }
    
    private func importBackup() {
        DocumentPicker.presentJSON { url in
            do {
                try BackupManager.importFromJSON(context: viewContext, url: url)
                alertMessage = LocalizedKeys.importSuccess.localized
            } catch {
                alertMessage = LocalizedKeys.importFailed.localized
            }
            showingAlert = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
