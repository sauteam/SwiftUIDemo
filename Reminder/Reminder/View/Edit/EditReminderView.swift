//
//  EditReminderView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct EditReminderView: View {
    //let reminder: Reminder
    //@EnvironmentObject var store: ReminderStore
    @StateObject private var viewModel: EditReminderViewModel
    @Environment(\.dismiss) var dismiss

//    @State private var title: String
//    @State private var dueDate: Date
//    @State private var notes: String
//    @State private var category: ReminderCategory
    
    init(store: ReminderStore, reminder: Reminder) {
       _viewModel = StateObject(wrappedValue: EditReminderViewModel(reminder: reminder, store: store))
    }
    
    private func saveChanges() {
        let _ = viewModel.saveChanges()
//        let updatedReminder = Reminder(
//            id: reminder.id,
//            title: title,
//            dueDate: dueDate,
//            isCompleted: reminder.isCompleted,
//            notes: notes.isEmpty ? nil : notes,
//            category: category,
//            notificationId: reminder.notificationId
//        )
//        
//        store.updateReminder(updatedReminder)
        // 如果启用了通知，更新通知
//        if let _ = updatedReminder.notificationId {
//            NotificationManager.shared.scheduleNotification(for: updatedReminder)
//        }
        dismiss()
    }

    var body: some View {
        Form {
            TextField("标题", text: $viewModel.title)
            DatePicker("截止日期", selection: $viewModel.dueDate)
            TextField("备注", text: $viewModel.notes)
            Picker("分类", selection: $viewModel.category) {
                ForEach(ReminderCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            
            Button("保存更改") {
//                let updatedReminder = Reminder(
//                    title: title,
//                    dueDate: dueDate,
//                    isCompleted: reminder.isCompleted,
//                    notes: notes.isEmpty ? nil : notes,
//                    category: category,
//                    notificationId: reminder.notificationId
//                )
                saveChanges()
                //store.updateReminder(updatedReminder)
                dismiss()
                
            }
            .disabled(viewModel.title.isEmpty)
        }
        .navigationTitle("编辑提醒")
        .onChange(of: viewModel.dueDate) { dueDate in
            print("数据已更新 \(dueDate)")
        }
    }
}
