// MARK: DEPRECATED

import Foundation
import SwiftUI
import UserNotifications

/*
class LocalNotifications {
    static let instance = LocalNotifications()
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in}
    }
    
    func scheduleNotifications() {
        let NotificationContent = UNMutableNotificationContent()
        NotificationContent.title = "Start Exploring CoddyBuddy"
        NotificationContent.sound = .default
        NotificationContent.body = "Check out the newest content and contribute to the community today."
        NotificationContent.badge = 1
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 05
        let NotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: NotificationContent,
            trigger: NotificationTrigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
 */

