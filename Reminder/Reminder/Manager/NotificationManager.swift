//
//  NotificationManager.swift
//  Reminder
//
//  Created by scy on 2024/12/27.
//

import UserNotifications
import UIKit

final class NotificationManager {
    static let shared = NotificationManager()
    var grantedPushNoti = false
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                self?.grantedPushNoti = true
                print("通知权限已获取")
            } else {
                print("通知权限被拒绝: \(error?.localizedDescription ?? "未知错误")")
            }
        }
    }
    
    func scheduleNotification(for reminder: Reminder) {
        if !grantedPushNoti {
            print("没有开启通知权限")
            return
        }
        if reminder.dueDate < Date()  {
            print("时间已过期 \(reminder.dateString)")
            return
        }
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "提醒事项"
        content.body  = reminder.title
        content.sound = .default
        content.badge = 1
        
        // 添加分类信息
        content.subtitle = "类别: \(reminder.category.rawValue)"
        
        if let notes = reminder.notes {
            content.body += "\n\(notes)"
        }
        
        // 创建触发器
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminder.dueDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // 创建请求
        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        // 添加通知请求
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("添加通知失败: \(error.localizedDescription)")
            } else {
                if reminder.dueDate > Date() {
                    print("成功设置通知，将在 \(reminder.dateString) 提醒")
                }
            }
        }
    }
    
    func cancelNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(
            withIdentifiers: [reminder.id.uuidString]
        )
    }
    
    // 检查通知权限状态
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // 获取所有待处理的通知
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    /// 点击通知消息跳转
    func handleNotificationResponse(_ response: UNNotificationResponse) {
         let identifier = response.notification.request.identifier
         if let reminderId = UUID(uuidString: identifier) {
             DispatchQueue.main.async {
                 AppCoordinator.shared.showReminder(reminderId)
             }
         }
        applicationIconBadgeNumber(0)
     }
    
    func applicationIconBadgeNumber(_ numbers: Int) {
        let number = max(0, numbers)
        UIApplication.shared.applicationIconBadgeNumber = number
    }
}
