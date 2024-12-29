//
//  ReminderDetailView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct ReminderDetailView: View {
    @Environment(\.dismiss) var dismiss
    let reminder: Reminder
    @EnvironmentObject var store: ReminderStore

    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            List {
                // 基本信息
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("标题")
                        Spacer()
                        Text(reminder.title)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("截止日期")
                        Spacer()
                        Text(reminder.dateString)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("分类")
                        Spacer()
                        Text(reminder.category.rawValue)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("状态")
                        Spacer()
                        Text(reminder.isCompleted ? "已完成" : "未完成")
                            .foregroundColor(reminder.isCompleted ? .green : .gray)
                    }
                }
                
                // 备注
                if let notes = reminder.notes, notes.isEmpty == false {
                    Section(header: Text("备注")) {
                        Text(notes)
                            .foregroundColor(.gray)
                    }
                }
                
                // 操作按钮
                Section {
                    Button(action: toggleComplete) {
                        HStack {
                            Spacer()
                            Text(reminder.isCompleted ? "标记为未完成" : "标记为已完成")
                                .foregroundColor(reminder.isCompleted ? .orange : .green)
                            Spacer()
                        }
                    }
                    
                    Button(action: { isEditing = true }) {
                        HStack {
                            Spacer()
                            Text("编辑提醒")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    
                    Button(action: deleteReminder) {
                        HStack {
                            Spacer()
                            Text("删除提醒")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("提醒详情")
            .navigationBarItems(trailing: Button("关闭") {
                dismiss()
            })
            .sheet(isPresented: $isEditing) {
                EditReminderView(store: store, reminder: reminder)
            }
            .onChange(of: reminder) { reminder in
                print("数据已更新 \(reminder.dueDate)")
            }
        }
    }
    
    private func toggleComplete() {
        var updatedReminder = reminder
        updatedReminder.isCompleted.toggle()
        store.updateReminder(updatedReminder)
        // 如果标记为完成，取消相关通知
        if updatedReminder.isCompleted {
            NotificationManager.shared.cancelNotification(for: updatedReminder)
        }
        dismiss()
    }
    
    private func deleteReminder() {
        store.deleteReminder(reminder)
        NotificationManager.shared.cancelNotification(for: reminder)
        dismiss()
    }
}
