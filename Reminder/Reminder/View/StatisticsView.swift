//
//  StatisticsView.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct StatisticsView: View {
    let store: ReminderStore
    
    var completedCount: Int {
        store.reminders.filter { $0.isCompleted }.count
    }
    
    var totalCount: Int {
        store.reminders.count
    }
    
    var categoryStats: [(ReminderCategory, Int)] {
        Dictionary(grouping: store.reminders, by: { $0.category })
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("完成进度")
                        .font(.headline)
                    Text("\(completedCount)/\(totalCount)")
                        .font(.title2)
                }
                
                Spacer()
                
                CircularProgressView(progress: Double(completedCount) / Double(max(totalCount, 1)))
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("分类统计")
                    .font(.headline)
                
                ForEach(categoryStats, id: \.0) { category, count in
                    HStack {
                        Text(category.rawValue)
                        Spacer()
                        Text("\(count)项")
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
        .frame(width: 50, height: 50)
    }
}
