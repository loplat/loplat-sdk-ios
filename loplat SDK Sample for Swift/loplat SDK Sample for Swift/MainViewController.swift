//
//  MainViewController.swift
//  loplat SDK Sample for Swift
//
//  Created by 상훈 on 31/07/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import Foundation
import Bohr
import CoreLocation
import PopupDialog
import MiniPlengi
import UserNotifications

class MainViewController: BOTableViewController {
    private var isOpened = false
    private var locationManager: CLLocationManager? = nil
    
    private var isLocationPermissionAllowed = false
    private var isNotificationPermissionAllowed = false
    
    override func setup() {
        super.setup()
        
        self.title = "MiniPlengi Sample (Swift)"
        self.requestLocationAlwaysPermission(isManual: false)
        
        // 권한 허용
        self.addSection(BOTableViewSection.init(headerTitle: "") { section -> Void in
            if let section = section {
                section.addCell(BOButtonTableViewCell(title: "위치 권한 (항상 허용) 허용하기", key: "location_permission") { cell in
                    let cellObj = cell as! BOButtonTableViewCell
                    
                    cellObj.actionBlock = {
                        if !self.isLocationPermissionAllowed {
                            self.requestLocationAlwaysPermission()
                        } else {
                            let popup = PopupDialog(title: "위치 권한 허용됨", message: "이미 위치권한이 허용되었습니다.")
                            popup.addButton(PopupDialogButton(title: "확인") {})
                            self.present(popup, animated: true, completion: nil)
                        }
                    }
                })
                
                section.addCell(BOButtonTableViewCell(title: "알림 권한 허용하기", key: "notification_permission") { cell in
                    let cellObj = cell as! BOButtonTableViewCell
                    
                    cellObj.actionBlock = {
                        if #available(iOS 10, *) {
                            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
                            UIApplication.shared.registerForRemoteNotifications()
                        } else if #available(iOS 9, *) {
                            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                })
                
                section.footerTitle = "로플랫 SDK를 사용하기 위해서는 위치 권한(항상 허용)은 필수로 필요하며, 알림 권한은 Gravity를 사용할 경우에 필요로 합니다. 권한 허용 API는 MiniPlengi에서는 제공하고 있지 않기에, 직접 구현하거나, developers.loplat.com을 참조해주세요."
            }
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") { section -> Void in
            if let section = section {
                section.addCell(BOTextTableViewCell(title: "클라이언트 아이디", key: "client_id") { cell -> Void in
                    let cellObj = cell as! BOTextTableViewCell
                    
                    cellObj.textField.placeholder = "client_id"
                })
                
                section.addCell(BOTextTableViewCell(title: "클라이언트 키", key: "client_secret") { cell -> Void in
                    let cellObj = cell as! BOTextTableViewCell
                    
                    cellObj.textField.placeholder = "client_secret"
                })
                
                section.addCell(BOTextTableViewCell(title: "에코 코드", key: "echo_code") { cell -> Void in
                    let cellObj = cell as! BOTextTableViewCell
                    
                    cellObj.textField.placeholder = "echo_code"
                })
                
                section.addCell(BOButtonTableViewCell(title: "SDK 초기화", key: "init") { cell in
                    let cellObj = cell as! BOButtonTableViewCell
                    
                    cellObj.actionBlock = {
                        var isClientFieldEmpty = true
                        if let client_id = UserDefaults.standard.string(forKey: "client_id"),
                            let client_password = UserDefaults.standard.string(forKey: "client_secret"),
                            let echo_code = UserDefaults.standard.string(forKey: "echo_code") {
                            if client_id != "" && client_password != "" {
                                isClientFieldEmpty = false
                                if Plengi.init(clientID: client_id, clientSecret: client_password, echoCode: echo_code) == .SUCCESS {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.registerPlaceEngineDelegate()
                                } else {
                                    let popup = PopupDialog(title: "이미 초기화 됨", message: "이미 SDK가 초기화 되었습니다.")
                                    popup.addButton(PopupDialogButton(title: "확인") {})
                                    self.present(popup, animated: true, completion: nil)
                                }
                            }
                        }
                        
                        if isClientFieldEmpty {
                            let popup = PopupDialog(title: "Client ID/Secret 입력 안됨", message: "필수 항목이 누락되었습니다.")
                            popup.addButton(PopupDialogButton(title: "확인") {})
                            self.present(popup, animated: true, completion: nil)
                        }
                    }
                })
                
                section.footerTitle = "로플랫으로부터 발급받은 client_id / client_secret을 입력한 후, SDK 초기화 버튼을 누르세요. \n\n주기의 단위는 '초' 이며, 최소 시간은 60초입니다. 60초 미만일 경우, 최저 주기인 60초로 자동 설정됩니다."
            }
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") { section -> Void in
            if let section = section {
                section.addCell(BOButtonTableViewCell(title: "SDK 시작", key: "start") { cell in
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.startSDK()
                })
                
                section.addCell(BOButtonTableViewCell(title: "SDK 정지", key: "stop") { cell in
                    let cellObj = cell as! BOButtonTableViewCell
                    
                    cellObj.actionBlock = {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.stopSDK()
                    }
                })
            }
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") { section -> Void in
            if let section = section {
                section.addCell(BOButtonTableViewCell(title: "장소 요청 (refreshPlace)", key: "refreshPlace") { cell in
                    let cellObj = cell as! BOButtonTableViewCell
                    
                    cellObj.actionBlock = {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.refreshPlace()
                    }
                })
                
                section.footerTitle = "해당 기능은 테스트 용도로만 사용되어야만 하며, 릴리즈 앱에서는 사용하지 마세요.\n\n릴리즈 앱에서는 start(interval) 메소드를 통해 타이머에 의해 동작이 되어야만 합니다."
            }
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") { section -> Void in
            if let section = section {
                section.addCell(BOSwitchTableViewCell(title: "Gravity 사용", key: "enable_gravity") { cell in
                    
                })
                
                section.footerTitle = "로플랫 광고 (Gravity)를 사용할 수 있습니다. 기본값은 SDK가 광고에 대한 알림을 처리하지만, 옵션에 따라 광고에 대한 이벤트를 직접 처리할 수 있습니다."
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isOpened {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let informationViewController = storyboard.instantiateViewController(withIdentifier: "informationViewController")
            
            self.present(informationViewController, animated: true, completion: nil)
            
            self.isOpened = true
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func requestLocationAlwaysPermission(isManual: Bool = true) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            if isManual {
                self.locationManager = CLLocationManager()
                locationManager?.requestAlwaysAuthorization()
            }
            
            break
            
        case .restricted, .denied:
            // Disable location features
            self.isLocationPermissionAllowed = false
            
            let popup = PopupDialog(title: nil, message: "위치 권한을 허용할 수 없습니다. 환경설정에서 직접 위치권한을 허용해주세요.")
            self.present(popup, animated: true, completion: nil)
            
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            self.isLocationPermissionAllowed = true
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            self.isLocationPermissionAllowed = true
            break
        }
    }
}
