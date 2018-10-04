//
//  Agreement.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 02/10/2018.
//  Copyright © 2018 Loplat. All rights reserved.
//
import UIKit
import CoreLocation
import UserNotifications

import MiniPlengi

enum Agreement: String, CaseIterable {
    case marketing = "Marketing_Agreement"
    case location  =  "Location_Agreement"
    
    public func observeValue(on: Bool, sender: NSObject) {
        if on {
            UserDefaults.standard.addObserver(sender, forKeyPath: self.rawValue, options: .new, context: nil)
        }
        else {
            UserDefaults.standard.removeObserver(sender, forKeyPath: self.rawValue)
        }
    }
    
    public var isOn: Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    public func setIsOn(_ on: Bool? = nil) {
        var defaultOn = false
        if on == nil {
            defaultOn = UserDefaults.standard.bool(forKey: self.rawValue)
            UserDefaults.standard.removeObject(forKey: self.rawValue)
        }
        let on = on ?? defaultOn
        UserDefaults.standard.set(on, forKey: self.rawValue)
        if on {
            self.on { isOn in
                UserDefaults.standard.set(isOn, forKey: self.rawValue)
            }
        }
        else {
            self.off()
        }
    }
    
    private func off() {
        switch self {
        case .marketing:
            _ = Plengi.enableAdNetwork(false)
            
        case .location:
            _ = Plengi.stop()
        }
    }
    
    private func on(completion: @escaping (Bool) -> Void) {
        switch self {
        case .marketing:
            if #available(iOS 10, *) {
                UNUserNotificationCenter.current().getNotificationSettings {
                    switch $0.authorizationStatus {
                    case .notDetermined:
                        completion(false)
                        DispatchQueue.main.async {
                            UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .badge, .sound]) { (granted, error) in
                                // return granted 'false' at first always
                                Agreement.marketing.setIsOn(true)
                            }
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    case .denied:
                        completion(false)
                        DispatchQueue.main.async {
                            guard let topMostViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() else {
                                return
                            }
                            let alert = UIAlertController.init(title: "알림 권한",
                                                               message: "알림 권한이 없습니다. \n설정에서 사용으로 변경해주세요.",
                                                               preferredStyle: .alert)
                            let move = UIAlertAction.init(title: "이동", style: .default) { action in
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                                alert.dismiss(animated: true,
                                              completion: nil)
                            }
                            alert.addAction(move)
                            let cancel = UIAlertAction.init(title: "취소", style: .cancel) { action in
                                alert.dismiss(animated: true,
                                              completion: nil)
                            }
                            alert.addAction(cancel)
                            topMostViewController.present(alert,
                                                          animated: true,
                                                          completion: nil)
                        }
                    default:
                        completion(true)
                    }
                }
            }
            else {
                if UIApplication.shared.isRegisteredForRemoteNotifications {
                    completion(true)
                }
                else {
                    completion(false)
                    UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            _ = Plengi.enableAdNetwork(true)
            
        case .location:
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                completion(false)
                UserDefaults.standard.set(true, forKey: "notDetermined")
                ViewController.locationManager.requestAlwaysAuthorization()
            case .authorizedWhenInUse, .restricted, .denied:
                completion(false)
                DispatchQueue.main.async {
                    guard let topMostViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() else {
                        return
                    }
                    let alert = UIAlertController.init(title: "위치 권한",
                                                       message: "위치 권한이 없습니다. \n설정에서 항상으로 변경해주세요.",
                                                       preferredStyle: .alert)
                    let move = UIAlertAction.init(title: "이동", style: .default) { action in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        alert.dismiss(animated: true,
                                      completion: nil)
                    }
                    alert.addAction(move)
                    let cancel = UIAlertAction.init(title: "취소", style: .cancel) { action in
                        alert.dismiss(animated: true,
                                      completion: nil)
                    }
                    alert.addAction(cancel)
                    topMostViewController.present(alert,
                                                  animated: true,
                                                  completion: nil)
                }
            case .authorizedAlways:
                completion(true)
                _ = Plengi.start()
            }
        }
    }
}
