//
//  AppCoordinator.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    static let shared = AppCoordinator()
    
    @Published var selectedReminderId: UUID?
    @Published var isShowingDetail = false
    
    func showReminder(_ id: UUID) {
        selectedReminderId = id
        isShowingDetail    = true
    }
}
