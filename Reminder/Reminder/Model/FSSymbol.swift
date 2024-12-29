//
//  FSSymbol.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import Foundation

enum ImageEnum: String, Codable {
    case edit  = "编辑"
    case trash = "删除"
    case done  = "完成"
    case willDone = "未完成"

    /// 系统icon名字
    var iconName: String {
        switch self {
        case .edit:
            return "pencil"
        case .trash:
            return "trash"
        case .done:
            return "xmark.circle"
        case .willDone:
            return "checkmark.circle"
        }
    }
}
