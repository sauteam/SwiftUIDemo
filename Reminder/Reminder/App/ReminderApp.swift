//
//  ReminderApp.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

@main
struct ReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = ReminderStore()
    var body: some Scene {
        WindowGroup {
            ReminderListView()
                .environmentObject(store)
        }
    }
}
