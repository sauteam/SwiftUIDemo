//
//  TodoItem.swift
//  Example
//
//  Created by SAUCHYE on 9/11/24.
//

let todoListDataKey = "todoListDataKey"


import Foundation

struct TodoItem: Identifiable, Codable {
    
    var id: UUID = UUID()
    var title: String
    var isFinish: Bool
    var isMark: Bool
    var upper: Int
    
    public static func upperIndex(_ p: Priority) -> Int {
        switch p {
        case .normal:
            return 0
        case .low:
            return 1
        case .high:
            return 2
        }
    }
}

enum TodoListKey: String, CaseIterable {
    case todo = "todoListDataKey"
    case done = "doneListDataKey"
    
//    var key: String {
//        switch self {
//        case .todo:
//            return "todoListDataKey"
//        case .done:
//            return "doneListDataKey"
//        }
//    }
}


enum Priority: Int, CaseIterable {
    case normal = 0
    case low    = 1
    case high   = 2
    
    var text: String {
        switch self {
        case .normal:
           return "常规"
        case .low:
            return "低先级"
        case .high:
            return "高优先级"
        }
    }
}

//struct TodoItem: Codable {
//    var id: UUID = UUID()
//    var title: String
//    var priority: Int
//    var isFinish: Bool
//    var isMark: Bool
//}

