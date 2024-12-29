//
//  ThemeManager.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

struct ThemeManager {
    static let categoryColors: [ReminderCategory: Color] = [
        .work: .blue,
        .personal: .green,
        .shopping: .orange,
        .health: .red
    ]
    
    static func color(for category: ReminderCategory) -> Color {
        return categoryColors[category]?.opacity(0.2) ?? .gray.opacity(0.2)
    }
}
