//
//  ReminderRowView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct ReminderRowView: View {
    let store: ReminderStore
    var reminder: Reminder
    //@EnvironmentObject var store: ReminderStore
    @State private var showingDetail = false
    
    private var isOverdue: Bool {
        !reminder.isCompleted && reminder.dueDate < Date()
    }
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    toggleComplete()
                }
            }) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminderColor)
                    .imageScale(.large)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .strikethrough(reminder.isCompleted)
                    .font(.headline)
                    .foregroundColor(isOverdue ? .red : .primary)
                
                HStack {
                    Text(reminder.dateString)
                        .font(.caption)
                        .foregroundColor(isOverdue ? .red : .gray)
                    
                    Text(reminder.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(ThemeManager.color(for: reminder.category))
                        .cornerRadius(8)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingDetail = true
            }
        }
        .sheet(isPresented: $showingDetail) {
            ReminderDetailView(reminder: reminder).environmentObject(store)
        }
        .id(reminder.id.uuidString + (reminder.isCompleted ? "completed" : "uncompleted"))
    }
    
    private var reminderColor: Color {
        if reminder.isCompleted {
            return .green
        } else if isOverdue {
            return .red
        } else {
            return .gray
        }
    }
    
    private func toggleComplete() {
        var updatedReminder = reminder
        updatedReminder.isCompleted.toggle()
        DispatchQueue.main.async {
            store.updateReminder(updatedReminder)
        }
    }
}
