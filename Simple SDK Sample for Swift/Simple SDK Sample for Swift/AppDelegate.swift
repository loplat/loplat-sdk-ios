//
//  AppDelegate.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//

import UIKit
import MiniPlengi
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application : UIApplication, didFinishLaunchingWithOptions launchOptions : [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        /*
         AppDelegate에는 반드시 아래의 두 메소드를 추가해주세요.
         Plengi.initialize(clientID:, clientSecret:)
         Plengi.start()
         이곳에서, Plengi.start()를 추가해주는 이유는
         백그라운드에서 App이 launching 됐을때 로플랫 SDK의 엔진이 start돼야 하기 때문입니다.
         */
        
        if Plengi.initialize(clientID: "loplatdemo",
                       clientSecret: "loplatdemokey",
                       echoCode: nil) == .SUCCESS {
            // 델리게이트를 설정해주셔야 위치 정보를 앱에서 사용할 수 있습니다.
            // 설정하지 않아도 SDK는 작동합니다.
            _ = Plengi.setDelegate(self)
        }
        
        // MainViewController 에서 Start된 이력이 있는 경우
        // AppDelegate에서 앱이 런칭될때(유저가 앱을 터치하여 켜거나 백그라운드에서 앱이 켜진 경우)
        // Plengi를 Start 해줍니다.
        // MainViewController 에서 Start된 이력이 없다면 백그라운드에서 동작하지 않습니다.
        if Plengi.getEngineStatus() == .STARTED {
            _ = Plengi.start()
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

