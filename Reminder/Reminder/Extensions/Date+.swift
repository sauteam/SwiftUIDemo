//
//  Date+.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.timeZone = TimeZone.current
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .short
        //formatter.locale    = Locale(identifier: "zh_CN")
        return formatter.string(from: self)
    }
}
