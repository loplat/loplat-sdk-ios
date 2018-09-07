//
//  AppDelegate.swift
//  loplat SDK Sample for Swift
//
//  Created by 상훈 on 31/07/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import UIKit
import Bohr
import PopupDialog

import MiniPlengi
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PlaceDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if ((launchOptions?.index(forKey: UIApplicationLaunchOptionsKey.location)) != nil) { // 앱이 백그라운드 모드로 재시작 되었을 때 (필수!!!!! 없으면 재시작 되지 않음)
            if let client_id = UserDefaults.standard.string(forKey: "client_id"),
                let client_password = UserDefaults.standard.string(forKey: "client_secret"),
                let echo_code = UserDefaults.standard.string(forKey: "echo_code") {
                if client_id != "" && client_password != "" {
                    if Plengi.init(clientID: client_id, clientSecret: client_password, echoCode: echo_code) == .SUCCESS {
                        _ = Plengi.start()
                    }
                }
            }
        }
        
        self.window = UIWindow()
        self.window?.frame = UIScreen.main.bounds
        self.window?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()
        
        self.setupAppearance()
        
        if #available(iOS  10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        UserDefaults.standard.addObserver(self, forKeyPath: "enable_gravity", options: [.new, .old], context: nil)
        
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "enable_gravity" {
            let enable_gravity = UserDefaults.standard.bool(forKey: "enable_gravity")
            self.setGravity(isEnabled: enable_gravity)
        }
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
        completionHandler([.alert,  .sound,  .badge])  // iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)
    }
    
    /// 로플랫 SDK에서 장소 인식 등 서버로부터 응답이 온 경우, 해당 Delegate가 호출됩니다.
    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        if plengiResponse.result == .SUCCESS {
            if plengiResponse.type == .PLACE_EVENT { // BACKGROUND
                if plengiResponse.place != nil {
                    if plengiResponse.placeEvent == .ENTER {
                        // PlaceEvent가 NEARBY 일 경우, NEARBY 로 인식된 장소 정보가 넘어옴
                        print(plengiResponse.place!.name)
                    } else if plengiResponse.placeEvent == .NEARBY {
                        // PlaceEvent가 ENTER 일 경우, 들어온 장소 정보 객체가 넘어옴
                    } else if plengiResponse.placeEvent == .LEAVE {
                        // PlaceEvent가 LEAVE 일 경우, 떠난 장소 정보 객체가 넘어옴
                    }
                }
                
                if plengiResponse.complex != nil {
                    // 복합몰이 인식되었을 때
                }
                
                if plengiResponse.area != nil {
                    // 상권이 인식되었을 때
                }
            }
        } else {
            /* 여기서부터는 오류인 경우입니다 */
            // [plengiResponse errorReason] 에 위치 인식 실패 / 오류 이유가 포함됨
            
            // FAIL : 위치 인식 실패
            // NETWORK_FAIL : 네트워크 오류
            // ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
        }
    }
    
    /// 로플랫 SDK에 Delegate를 등록합니다.
    /// `Plengi.setDelegate` 메소드는 반환값이 있으며, 등록 성공 시 `PlengiResponse.Result.SUCCESS`가, 실패 시 `PlengiResponse.Result.FAIL` 이 반환됩니다.
    func registerPlaceEngineDelegate() {
        if Plengi.setDelegate(self) == .SUCCESS {
            
        } else {
            let popupDialog = PopupDialog(title: "초기화에 실패하였습니다.", message: "Plengi.setDelegate() 메소드에서 FAILED를 반환했습니다.")
            popupDialog.addButton(PopupDialogButton(title: "확인") {})
            self.window?.rootViewController?.present(popupDialog, animated: true, completion: nil)
        }
    }
    
    /// 로플랫 SDK를 시작합니다.
    func startSDK() {
        if Plengi.start() == .FAIL {
            let popupDialog = PopupDialog(title: "SDK를 시작할 수 없음", message: "SDK가 이미 시작 상태입니다.")
            popupDialog.addButton(PopupDialogButton(title: "확인") {})
            self.window?.rootViewController?.present(popupDialog, animated: true, completion: nil)
        }
    }
    
    /// 로플랫 SDK를 정지합니다.
    func stopSDK() {
        if Plengi.stop() == .FAIL {
            let popupDialog = PopupDialog(title: "SDK를 정지할 수 없음", message: "SDK가 이미 정지 상태입니다.")
            popupDialog.addButton(PopupDialogButton(title: "확인") {})
            self.window?.rootViewController?.present(popupDialog, animated: true, completion: nil)
        }
    }
    
    /// 장소 인식 요청을 수동으로 호출합니다.
    /// 경고 : 실제 릴리즈 앱에서는 해당 기능을 사용하지 마세요. 테스트 용도로만 사용해주세요.
    func refreshPlace() {
        _ = Plengi.refreshPlace()
    }
    
    func setGravity(isEnabled: Bool) {
        print("OK")
        _ = Plengi.enableAdNetwork(isEnabled)
    }

    private func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 71 / 255.0, green: 165.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UITableView.appearance().backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        
        BOTableViewSection.appearance().headerTitleColor = UIColor.init(white: 0.5, alpha: 1)
        BOTableViewSection.appearance().footerTitleColor = UIColor.init(white: 0.6, alpha: 1)
        
        BOTableViewCell.appearance().mainColor = UIColor.init(white: 0.3, alpha: 1)
        BOTableViewCell.appearance().secondaryColor = UIColor.init(red: 71 / 255.0, green: 165.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
        BOTableViewCell.appearance().selectedColor = UIColor.init(red: 71 / 255.0, green: 165.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
}

