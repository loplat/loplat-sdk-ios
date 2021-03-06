//
//  AppDelegate+Notification.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//
import UserNotifications
import MiniPlengi

/*
 아래의 메소드를 적용해주시면 loplat X와 연계된 캠페인 메시지를 받으실수 있습니다.
 */
@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = Plengi.processLoplatAdvertisement(center,
                                              didReceive: response,
                                              withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

@available(iOS, deprecated: 10.0)
extension AppDelegate {
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     for notification: UILocalNotification,
                     completionHandler: @escaping () -> Void) {
        _ = Plengi.processLoplatAdvertisement(application,
                                              handleActionWithIdentifier: identifier,
                                              for: notification,
                                              completionHandler: completionHandler)
    }
}
