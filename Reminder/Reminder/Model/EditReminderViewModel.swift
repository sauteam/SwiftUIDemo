//
//  Edit.swift
//  Reminder
//
//  Created by scy on 2024/12/28.
//

import Foundation
import SwiftUI

class EditReminderViewModel: ObservableObject {
    @Published var title: String
    @Published var dueDate: Date
    @Published var notes: String
    @Published var category: ReminderCategory
    @Published var isCompleted: Bool
    
    private let originalReminder: Reminder
    private let store: ReminderStore
    
    init(reminder: Reminder, store: ReminderStore) {
        self.originalReminder = reminder
        self.store = store
        
        self.title = reminder.title
        self.dueDate = reminder.dueDate
        self.notes = reminder.notes ?? ""
        self.category = reminder.category
        self.isCompleted = reminder.isCompleted
    }
    
    func saveChanges() -> Bool {
        guard !title.isEmpty else { return false }
        
        let updatedReminder = Reminder(
            id: originalReminder.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: dueDate,
            isCompleted: isCompleted,
            notes: notes.isEmpty ? nil : notes.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            notificationId: originalReminder.notificationId
        )
        store.updateReminder(updatedReminder)
        if let _ = updatedReminder.notificationId {
            NotificationManager.shared.scheduleNotification(for: updatedReminder)
        }
        return true
    }
}
