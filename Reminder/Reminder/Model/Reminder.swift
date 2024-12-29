//
//  ReminderModel.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import Foundation
import SwiftUI

struct Reminder:Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool
    var notes: String?
    var category: ReminderCategory
    var notificationId: String?
    
    var dateString: String {
        return dueDate.formattedString()
    }
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
}

enum ReminderCategory: String, Codable, CaseIterable {
    case work     = "工作"
    case personal = "个人"
    case shopping = "购物"
    case health   = "健康"
    case daily    = "日常"
    case other    = "其他"
    
    /// 颜色
    var color: Color {
        switch self {
        case .work:
            return Color.blue.opacity(0.2)
        case .personal:
            return Color.green.opacity(0.2)
        case .shopping:
            return Color.orange.opacity(0.2)
        case .health:
            return Color.red.opacity(0.2)
        case .daily:
            return Color.gray.opacity(0.2)
        case .other:
            return Color.purple.opacity(0.2)
        }
    }
}


