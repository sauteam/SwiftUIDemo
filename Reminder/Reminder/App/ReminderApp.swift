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

    var body: some Scene {
        WindowGroup {
            ReminderListView()
        }
    }
}
