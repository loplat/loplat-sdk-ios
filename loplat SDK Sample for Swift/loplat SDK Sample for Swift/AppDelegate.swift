//
//  AppDelegate.swift
//  loplat SDK Sample for Swift
//
//  Created by 상훈 on 31/07/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import UserNotifications
import MiniPlengi

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 앱이 백그라운드 모드로 재시작 되었을 때 MiniPlengi를 재시작합니다.
        // 초기화를 didFinishLaunchingWithOptions 에서 항상 하지 않는다면
        // 꼭 아래와 같은 작업을 하셔야합니다.
        if ((launchOptions?.index(forKey: UIApplication.LaunchOptionsKey.location)) != nil) {
            guard let echo_code = UserDefaults.standard.string(forKey: "echo_code") else {
                return false
            }
            if self.initPlengi(echoCode: echo_code) {
                _ = Plengi.start()
                Plengi.isDebug = true
            }
        }
        
        self.window = UIWindow()
        self.window?.frame = UIScreen.main.bounds
        self.window?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()
        
        if #available(iOS  10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "processAdvertisement"), object: nil) // SDK 내부 이벤트 호출 (정확한 처리를 위해 권장)
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        _ = Plengi.processLoplatAdvertisement(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
    }
    
    @available(iOS 10.0,  *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ()  ->  Void) {
        _ = Plengi.processLoplatAdvertisement(center, didReceive: response, withCompletionHandler: completionHandler)
        completionHandler()  // loplat SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리하기 위한 코드
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping  (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])  // iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)
    }
    
    public func initPlengi(echoCode: String) -> Bool {
        return Plengi.init(clientID: "loplatdemo",
                           clientSecret: "loplatdemokey",
                           echoCode: echoCode) == .SUCCESS
    }
}

