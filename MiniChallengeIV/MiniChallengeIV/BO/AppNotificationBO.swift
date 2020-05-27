//
//  NotificationBO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 04/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import NotificationCenter
import UserNotifications
import Foundation

enum NotificationType: String {
    case didFinishFocus, didFinishBreak, didLoseFocus, comeBackToTheApp
}

enum ActionNotification: String {
    case beginBreak, beginFocus
}

class AppNotificationBO: NSObject {
    
    //MARK:- Singleton setup
    static let shared = AppNotificationBO()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        requestAuthorazition()
//        configureCategory()
    }
    
    //MARK:- Attributes
    private var badgeNumber: Int {
        get {
            UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var bgTask = UIBackgroundTaskIdentifier.invalid
    
    func sendNotification(type: NotificationType, delay: TimeInterval = 2) {
        var localizedTitle: String?
        var localizedBody: String?
        switch type {
        case .didLoseFocus:
            localizedTitle = NSLocalizedString("Lost Focus Notification", comment: "")
            localizedBody = NSLocalizedString("Lost Focus Body", comment: "")
        case .didFinishFocus:
            localizedTitle = NSLocalizedString("End Focus Notification", comment: "")
            localizedBody = NSLocalizedString("End Focus Body", comment: "")
        case .didFinishBreak:
            localizedTitle = NSLocalizedString("Break Notification", comment: "")
            localizedBody = NSLocalizedString("Break Body", comment: "")
        case .comeBackToTheApp:
            localizedTitle = NSLocalizedString("Long Time Notification", comment: "")
            localizedBody = NSLocalizedString("Long Time Body", comment: "")
            
        }
        if let title = localizedBody,
            let body = localizedTitle{
            sendNotification(title: title, subtitle: "", body: body, category: type, delay: delay)
        }
    }
    
    func resetBagde() {
        DispatchQueue.main.async {
            self.badgeNumber = 0
        }
    }
    
}

extension AppNotificationBO {

    private func requestAuthorazition() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    private func checkAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("Notifications Denied")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    private func sendNotification(title: String, subtitle: String, body: String, category: NotificationType? = .none, delay: TimeInterval? = 0, repeats: Bool? = false) {
        
        checkAuthorization() { allow in
            guard allow else { return }
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.subtitle = subtitle
            notificationContent.body = body
            notificationContent.sound = UNNotificationSound.default
            print(notificationContent.categoryIdentifier)
            notificationContent.categoryIdentifier = category!.rawValue

            DispatchQueue.main.async {
                notificationContent.badge = NSNumber(value: self.badgeNumber + 1)
            }
            
            //            let t = UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: false) // Agendar notificação para a próxima hora == dateMatching
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay!, repeats: repeats!)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            self.notificationCenter.add(request)
        }
    }

    private func configureCategory() {
        // Define Actions
        let beginFocus = UNNotificationAction(identifier: ActionNotification.beginFocus.rawValue, title: "Iniciar foco", options: [])
        let beginBreak = UNNotificationAction(identifier: ActionNotification.beginBreak.rawValue, title: "Iniciar pausa", options: [])

        // Define Category
        let focusCategory = UNNotificationCategory(identifier: NotificationType.didFinishBreak.rawValue, actions: [beginFocus], intentIdentifiers: [], options: [])
        let breakCategory = UNNotificationCategory(identifier: NotificationType.didFinishFocus.rawValue, actions: [beginBreak], intentIdentifiers: [], options: [])

        // Register Category
        UNUserNotificationCenter.current().setNotificationCategories([focusCategory, breakCategory])
    }

}

extension AppNotificationBO: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case ActionNotification.beginBreak.rawValue:
//            vc.startTimer()
            print("Break tapped")
        case ActionNotification.beginFocus.rawValue:
            print("Focus tapped")
        default:
            print("Other Action")
        }

        completionHandler()
    }
}

extension AppNotificationBO {
    //MARK:- Background task
    
    func registerBgTask(timeRecover: TimeRecoverBO) {
        bgTask = UIApplication.shared.beginBackgroundTask {
            let brightness = UIScreen.main.brightness
            if brightness > 0 {
                if timeRecover.timer.state == .focus {
                    self.sendNotification(type: .didLoseFocus)
                }
                timeRecover.backgroundStatus = .homeScreen
            } else {
                timeRecover.backgroundStatus = .lockScreen
            }
            
            self.removeBgTask()
        }
    }
    
    func removeBgTask() {
        UIApplication.shared.endBackgroundTask(self.bgTask)
        self.bgTask = .invalid
    }
    
}
