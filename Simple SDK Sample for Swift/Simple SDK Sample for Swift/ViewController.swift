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
    
    
    /*
     MainViewController에서 유저에게 시스템 권한과 앱에서 관리하는 위치 권한을 받은 사용자에 대하여 Start를 호출해 주십시오.
     ***!!! 주의 : Plengi.start()를 명시적으로 호출하지 않으면 백그라운드에서 작동하지 않습니다.
     */
    @IBAction func loginAndPlengiStart(_ sender: UIButton) {
        let start = Plengi.start()
        print(start.rawValue)
    }
    
    private let locationManager = CLLocationManager()
    private let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationCenter.addObserver(self, selector: #selector(recievePlengiResponse), name: .pr, object: nil)
        
        
        
        // MARK:- 위치 권한 요청
        self.locationManager.delegate = self
        
        // 버전별 권한 요청
        // iOS 13.4 이상의 경우 WhenInUse 권한을 먼저 요청
        if #available(iOS 13.4, *) {
            locationManager.requestWhenInUseAuthorization()
        } else { // iOS 13.4 미만은 Always 권한 요청
            locationManager.requestAlwaysAuthorization()
        }
       
    }
    
    // MARK:- 알람 권한 요청
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

// MARK:- 버전별 위치 권한
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
                
                // 앱 사용 중 또는 항상 권한을 받았을때, 알림요청을 해준다.
                self.alertRequest()
            }
        }
    }
    
    
}


// MARK:- 앱 델리게이트에서 받은 plengiResponse
// SDK가 시작되고 약 2분 뒤, 첫 이벤트를 받습니다.
// Plengi.start()의 return 값의 rawValue가 0인 것을 확인하시고
// 약 2 분뒤 콘솔창에 결과 값을 확인하세요.
extension ViewController {
   
    @objc private func recievePlengiResponse() {
        if let plengiResponseData = UserDefaults.standard.data(forKey: "plengiResponse") {
            if let pr = NSKeyedUnarchiver.unarchiveObject(with: plengiResponseData) as? PlengiResponse {
                if let place = pr.place {
                    print(place.name)
                }
                
                if let area = pr.area {
                    print(area.name)
                }
                
                if let district = pr.district {
                    print(district.lv1_name, district.lv2_name, district.lv3_name)
                }
            }
        }
    }
}
