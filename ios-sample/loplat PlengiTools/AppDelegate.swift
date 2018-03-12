//
//  AppDelegate.swift
//  loplat PlengiTools
//
//  Created by 상훈 on 20/02/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import UIKit
import MiniPlengi

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PlaceDelegate {

    var window: UIWindow?
    var plengi: Plengi?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if ((launchOptions?.index(forKey: UIApplicationLaunchOptionsKey.location)) != nil) { //해당 코드는 필수입니다! 앱이 사용자로부터 아예 종료되었을 때, 시스템으로부터 백그라운드로 앱을 재실행하기 위함입니다. 꼭 해당 if 문을 작성하여, Plengi 인스턴스를 초기화하는 코드를 포함시켜주세요.
            print("App was restarted! INIT PLENGI SUCCESSFULLY.")
            initPlengi()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.initPlengi), name: NSNotification.Name(rawValue: "initPlengi"), object: nil) // ViewController에서 initPlengi 라는 이벤트를 송신했을때, 해당 클래스 AppDelegate에서 initPlengi 이벤트를 수신합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLocation), name: NSNotification.Name(rawValue: "refreshLocation"), object: nil) // ViewController에서 refreshLocation 라는 이벤트를 송신했을때, 해당 클래스 AppDelegate에서 refreshLocation 이벤트를 수신합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkBL), name: NSNotification.Name(rawValue: "checkBLE"), object: nil) // ViewController에서 checkBLE 라는 이벤트를 송신했을때, 해당 클래스 AppDelegate에서 checkBLE 이벤트를 수신합니다.
        
        self.window?.makeKeyAndVisible()
        
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
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        plengi?.processLoplatAdvertisement(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
    }

    func didEnterPlace(_ currentPlace: Place) {
        
    }
    
    func didLeavePlace(_ previousPlace: Place?) {
        
    }
    
    func whereIsNow(_ currentPlace: Place) {
        NotificationCenter.default.post(name: NSNotification.Name("receiveCurrentPlace"), object: self, userInfo: ["placename": currentPlace.name, "subname": currentPlace.tags, "floor": currentPlace.floor, "address": currentPlace.address, "placeid": currentPlace.loplat_id, "accuracy": currentPlace.accuracy])
    }
    
    @objc func refreshLocation() {
        plengi?.refreshLocation()
    }
    
    @objc func initPlengi() {
        plengi = Plengi.initPlaceEngine(client_id: "test", client_secret: "test", isRMainThread: false) // 로플랫에서 발급받은 클라이언트 아이디와 시크릿 코드를 넣어줍니다.
        plengi?.delegate = self
        
        plengi?.gpsRecognitionType = .HIGH //GPS 정확도 매우 높음
        plengi?.recognitionType = .High //비콘 사용함
        
        plengi?.enableAd() //Gravity
        plengi?.registerLoplatAdvertisement() //Gravity
        
        plengi?.start(30)
    }
    
    @objc func checkBL() {
        NotificationCenter.default.post(name: NSNotification.Name("receiveBLStatus"), object: self, userInfo: ["isEnabled": (plengi?.isBLEnabled())!]) // Broadcast를 보낼 때, 데이터도 같이 보내줌 (userInfo)
        
        if (!(plengi?.isBLEnabled())!) {
            plengi?.requestBluetooth()
        }
    }
}

