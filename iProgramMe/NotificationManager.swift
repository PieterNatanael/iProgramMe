//
//  NotificationManager.swift
//  iProgramMeExperiment1
//
//  Created by Pieter Yoshua Natanael on 30/09/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    static func scheduleNotification(notification: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = "iProgramMe"
        content.body = notification.text
        content.sound = UNNotificationSound(named: UNNotificationSoundName("Duck"))

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notification.notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

    static func loadNotifications() -> [NotificationData] {
        if let data = UserDefaults.standard.data(forKey: "notificationsKey"),
           let decoded = try? JSONDecoder().decode([NotificationData].self, from: data) {
            return decoded
        }
        return []
    }

    static func saveNotifications(notifications: [NotificationData]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: "notificationsKey")
        }
    }
}
