//
//  NotificationBO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 04/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import NotificationCenter
import UserNotifications

enum NotificationType {
    case didFinishFocus, didFinishBreak, didLoseFocus, comeBackToTheApp
}

class AppNotificationBO {
    //MARK:- Singleton setup
    static let shared = AppNotificationBO()
    
    private init() {}
    
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
    
    //MARK:- Methods
    func requestAuthorazition() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func sendNotification(type: NotificationType, delay: TimeInterval = 2) {
        switch type {
        case .didLoseFocus:
            sendNotification(title: "Perdeu o foco", subtitle: "", body: "Concentre-se para manter a produtividade")
        case .didFinishFocus:
            sendNotification(title: "Tempo de foco terminado", subtitle: "", body: "Já pode iniciar sua pausa", delay: delay)
        case .didFinishBreak:
            sendNotification(title: "Pausa terminada", subtitle: "", body: "Hora de voltar ao trabalho", delay: delay)
        case .comeBackToTheApp:
            sendNotification(title: "É hora de voltar a focar", subtitle: "", body: "Já faz tempo que não te vejo. Vamos voltar a focar em suas tarefas com o 'AppFoco'")
        }
    }
    
    private func sendNotification(title: String, subtitle: String, body: String, delay: TimeInterval? = 2, repeats: Bool? = false) {
        
        checkAuthorization() { allow in
            guard allow else { return }
           
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.subtitle = subtitle
            notificationContent.body = body
            notificationContent.sound = UNNotificationSound.default

            DispatchQueue.main.async {
                notificationContent.badge = NSNumber(value: self.badgeNumber + 1)
            }
            
            //            let t = UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: false) // Agendar notificação para a próxima hora == dateMatching
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay!, repeats: repeats!)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            self.notificationCenter.add(request)
        }
    }
    
    func resetBagde() {
        DispatchQueue.main.async {
            self.badgeNumber = 0
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
    
    //MARK:- Background task
    var bgTask = UIBackgroundTaskIdentifier.invalid
    
    func registerBgTask() {
        print("Background registered")
        bgTask = UIApplication.shared.beginBackgroundTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let brightness = UIScreen.main.brightness
                if brightness > 0 {
                    self.sendNotification(type: .didLoseFocus)
                    // parar timer
                }
            }
            
            self.removeBgTask()
        }
    }
    
    func removeBgTask() {
        UIApplication.shared.endBackgroundTask(bgTask)
        bgTask = .invalid
    }
    
}
