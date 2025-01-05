//
//  ReminderListView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct ReminderListView: View {
    @EnvironmentObject var store: ReminderStore
    @State private var selectedReminder: Reminder?
    //@ObservedObject var store: ReminderStore
    @StateObject private var coordinator = AppCoordinator.shared
    @State private var showingAddReminder = false
    @State private var selectedCategory: ReminderCategory?
    @State private var searchText = ""
    @State private var showingStatistics = false
    @State private var reminders: [Reminder] = []

    // MARK: - Computed Properties
    private var filteredReminders: [Reminder] {
        var results = store.reminders
        if let category = selectedCategory {
            results = results.filter { $0.category == category }
        }
        if !searchText.isEmpty {
            results = results.filter { reminder in
                reminder.title.localizedCaseInsensitiveContains(searchText) ||
                (reminder.notes ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        // 按日期排序
        return results.sorted { $0.dueDate > $1.dueDate }
    }
    
    private var groupedReminders: [Date: [Reminder]] {
        Dictionary(grouping: filteredReminders) { reminder in
            Calendar.current.startOfDay(for: reminder.dueDate)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchText)
                    .padding(.vertical, 8)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(
                            title: "全部",
                            isSelected: selectedCategory == nil
                        ) {
                            withAnimation {
                                selectedCategory = nil
                            }
                        }
                        
                        ForEach(ReminderCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                // 提醒列表
                if filteredReminders.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(filteredReminders, id: \.id) { reminder in
                            NavigationLink(destination: EditReminderView(store: store, reminder: reminder)) {
                                ReminderRowView(store: store, reminder: reminder)
                                    .id(reminder.id)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                for index in indexSet {
                                    store.deleteReminder(filteredReminders[index])
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .onChange(of: store.reminders) { list in
                        reminders = list
                        print("列表数据变化 \(list)")
                    }
                }
            }
            .navigationTitle("提醒事项")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingStatistics = true
                    } label: {
                        Image(systemName: "chart.bar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddReminder = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(store: store)
            }
            .sheet(isPresented: $coordinator.isShowingDetail) {
                if let reminderId = coordinator.selectedReminderId,
                   let reminder = store.findReminder(reminderId) {
                    ReminderDetailView(reminder: reminder).environmentObject(store)
                }
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsView(store: store)
                    .presentationDetents([.medium])
            }
            .onAppear {
                reminders = store.reminders
            }
        }
    }
    
    private func sectionTitle(for date: Date) -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        if date == today {
            return "今天"
        } else if date == tomorrow {
            return "明天"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "M月d日 EEEE"
            return formatter.string(from: date)
        }
    }
}

#Preview {
    ReminderListView()
}
