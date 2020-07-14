//
//  ViewController.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//

import UIKit
import CoreLocation
import MiniPlengi
import UserNotifications

class ViewController: UIViewController {
    
    @IBAction func loginAndPlengiStart(_ sender: UIButton) {
        let start = Plengi.start()
        print(start.rawValue)
    }
    
    
    private let locationManager = CLLocationManager()
    private let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.notificationCenter.addObserver(self, selector: #selector(recievePlengiResponse), name: .pr, object: nil)
        
        // 버전별 권한 요청
        // iOS 13.4 이상의 경우 WhenInUse 권한을 먼저 요청
        if #available(iOS 13.4, *) {
            locationManager.requestWhenInUseAuthorization()
        } else { // iOS 13.4 미만은 Always 권한 요청
            locationManager.requestAlwaysAuthorization()
        }
       
    }
    
    private func alertRequest() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current()
                .requestAuthorization(options:[.badge, .alert, .sound]) { (granted,error) in}
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(
                UIUserNotificationSettings(types: [.badge, .sound, .alert],
                                           categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
 
}

// MARK:- 위치 권한에 따른 시나리오
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // iOS 13.4 이상의 경우 status가 WhenInUse 일 때, Always권한 재요청
        if #available(iOS 13.4, *) {
            if status == .authorizedWhenInUse {
                
                // 앱 사용 중 권한을 받았을때, start()를 해준다.
                self.locationManager.requestAlwaysAuthorization()
            } else if status == .authorizedAlways {
                // 알림 권한 요청
                self.alertRequest()
            }
        } else {
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                // 알림 권한 요청
                
                // 앱 사용 중 또는 항상 권한을 받았을때, start()를 해준다.
                self.alertRequest()
            }
        }
    }
    
    
}


extension ViewController {
   
    
    @objc private func recievePlengiResponse() {
        if let plengiResponseData = UserDefaults.standard.data(forKey: "plengiResponse") {
            if let pr = NSKeyedUnarchiver.unarchiveObject(with: plengiResponseData) as? PlengiResponse {
                if let place = pr.place {
                    print(place.name)
                }
            }
        }
    }
}
