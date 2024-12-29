//
//  ReminderStore.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import Foundation

final class ReminderStore: ObservableObject {
    //@Published private var updateTrigger = UUID()
    @Published var reminders: [Reminder] = [] {
        didSet {
            saveReminders()
        }
    }
    private let saveKey = "SavedReminders"
    
    init() {
        loadReminders()
    }
    
    func searchReminders(with searchText: String) -> [Reminder] {
        guard !searchText.isEmpty else { return reminders }
        return reminders.filter { reminder in
            reminder.title.localizedCaseInsensitiveContains(searchText) ||
            (reminder.notes ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
        NotificationManager.shared.scheduleNotification(for: reminder)
        willChangeSend()
    }
    
    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveReminders()
            NotificationManager.shared.scheduleNotification(for: reminder)
            willChangeSend()
        } else {
            print("未找到要更新的提醒\(reminder.dateString)")
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders.remove(at: index)
            saveReminders()
            NotificationManager.shared.cancelNotification(for: reminder)
            willChangeSend()
        }
    }
        
    func findReminder(_ id: UUID) -> Reminder? {
        return reminders.first(where: { $0.id == id })
    }
    
    private func willChangeSend() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.objectWillChange.send()
        }
    }
        
    private let storageURL: URL = {
         let fileManager = FileManager.default
         let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
         return documentsURL.appendingPathComponent("reminders.json")
     }()
    
    private func loadReminders() {
        do {
            let data = try Data(contentsOf: storageURL)
            reminders = try JSONDecoder().decode([Reminder].self, from: data)
        } catch {
            print("Failed to load reminders: \(error)")
            reminders = [] // 如果读取失败，初始化为空数组
        }
    }
    
    private func saveReminders() {
        do {
            let data = try JSONEncoder().encode(reminders)
            try data.write(to: storageURL)
        } catch {
            print("Failed to save reminders: \(error)")
        }
    }
}


//        if let data = UserDefaults.standard.data(forKey: saveKey),
//           let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
//            reminders = decoded
//        }

//        if let encoded = try? JSONEncoder().encode(reminders) {
//            UserDefaults.standard.set(encoded, forKey: saveKey)
//        }

