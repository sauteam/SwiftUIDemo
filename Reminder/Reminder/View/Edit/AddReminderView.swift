//
//  AddReminderView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    let store: ReminderStore
    
    // 表单数据
    @State private var title = ""
    @State private var dueDate = Date()
    @State private var notes   = ""
    @State private var category: ReminderCategory = .personal
    @State private var isNotificationEnabled = true
    
    // 验证状态
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var notificationStatus: Bool = false
    
    private func checkNotificationPermission() {
       NotificationManager.shared.checkNotificationStatus { status in
           if !status {
               alertMessage = "请在设置中启用通知权限，否则无法收到提醒"
               showingAlert = true
               isNotificationEnabled = false
           }
           notificationStatus = status
       }
   }
    
    var body: some View {
        NavigationView {
            Form {
                // 基本信息区域
                Section(header: Text("基本信息")) {
                    TextField("标题", text: $title)
                    
                    DatePicker("截止日期", selection: $dueDate, in: Date()...)
                    
                    Picker("分类", selection: $category) {
                        ForEach(ReminderCategory.allCases, id: \.self) { category in
                            HStack {
                                Circle()
                                    .fill(ThemeManager.color(for: category))
                                    .frame(width: 10, height: 10)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }
                
                // 备注区域
                Section(header: Text("备注")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                // 通知设置区域
                Section(header: Text("通知设置")) {
                    Toggle("启用提醒", isOn: $isNotificationEnabled)
                    if isNotificationEnabled {
                        HStack {
                            Text("提醒时间")
                            Spacer()
                            Text(dueDate.formatted(date: .omitted, time: .shortened))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // 保存按钮区域
                Section {
                    Button(action: saveReminder) {
                        HStack {
                            Spacer()
                            Text("保存提醒")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(!isValidForm)
                }
            }
            .navigationTitle("新建提醒")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveReminder()
                }
                .disabled(!isValidForm)
            )
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear() {
                checkNotificationPermission()
            }
        }
    }
    
    // 表单验证
    private var isValidForm: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // 保存提醒
    private func saveReminder() {
        // 验证标题
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "请输入提醒标题"
            showingAlert = true
            return
        }
        
        if isNotificationEnabled {
            // 验证日期
            guard dueDate > Date() else {
                alertMessage = "截止日期必须是未来时间"
                showingAlert = true
                return
            }
        }
        
        // 创建新提醒
        let reminder = Reminder(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: dueDate,
            isCompleted: false,
            notes: notes.isEmpty ? nil : notes.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            notificationId: isNotificationEnabled ? UUID().uuidString : nil
        )
        // 保存提醒
        store.addReminder(reminder)
        // 关闭视图
        dismiss()
    }
}

// 预览
struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView(store: ReminderStore())
    }
}

// 辅助视图
private struct FormHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }
}
