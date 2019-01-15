//
//  MainViewController.swift
//  loplat SDK Sample for Swift
//
//  Created by 상훈 on 31/07/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import CoreLocation
import UserNotifications

import Bohr
import PopupDialog

import MiniPlengi

class MainViewController: BOTableViewController {
    private var isOpened = false
    private let locationManager = CLLocationManager()
    private var engineStatusSection: BOTableViewSection! = nil
    
    private var engineStatusMessage: String {
        return "MiniPlengi is " + (Plengi.getEngineStatus() == .STARTED ? "started" : "stopped")
    }
    
    private var enableGravity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "enable_gravity")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "enable_gravity")
        }
    }
    
    private var locationAgreement: Bool {
        return UserDefaults.standard.bool(forKey: "locationAgreement")
    }
    
    private var marketingAgreement: Bool {
        return UserDefaults.standard.bool(forKey: "marketingAgreement")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isOpened {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let informationViewController = storyboard.instantiateViewController(withIdentifier: "informationViewController")
            
            self.present(informationViewController, animated: true, completion: nil)
            
            self.isOpened = true
        }
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupAppearance() {
        
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
    
    override func setup() {
        super.setup()
        
        self.title = "MiniPlengi Sample (Swift)"
        
        // 권한 허용
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOButtonTableViewCell(title: "위치 권한 (항상 허용) 허용하기",
                                                  key: "location_permission") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined:
                        self.locationManager.requestAlwaysAuthorization()
                    case .authorizedWhenInUse, .restricted, .denied:
                        self.customAlert(title: "위치 권한",
                                         message: "위치 권한이 없습니다. \n설정에서 항상으로 변경해주세요.",
                                         action: "이동",
                                         cancel: "취소") {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                if #available(iOS 10.0, *) {
                                                    UIApplication.shared.open(url)
                                                } else {
                                                    UIApplication.shared.openURL(url)
                                                }
                                            }
                        }
                    case .authorizedAlways:
                        self.customAlert(title: "위치 권한 허용됨",
                                         message: "이미 위치권한이 허용되었습니다.")
                    }
                }
            })
            
            section.addCell(BOButtonTableViewCell(title: "알림 권한 허용하기",
                                                  key: "notification_permission") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    if #available(iOS 10, *) {
                        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {
                            switch $0.authorizationStatus {
                            case .notDetermined:
                                DispatchQueue.main.async {
                                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                            case .denied:
                                self.customAlert(title: "알림 권한",
                                                 message: "알림 권한이 없습니다. \n설정에서 사용으로 변경해주세요.",
                                                 action: "이동",
                                                 cancel: "취소") {
                                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                                        UIApplication.shared.open(url)
                                                    }
                                }
                            case .authorized:
                                self.customAlert(title: "알림 권한 허용됨",
                                                 message: "이미 알림권한이 허용되었습니다.")
                            case .provisional:
                                self.customAlert(title: "알림 권한 허용됨",
                                                 message: "알림이 조용히 전달 상태입니다.")
                            }
                        })
                    }
                    else {
                        if !UIApplication.shared.isRegisteredForRemoteNotifications {
                            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        else {
                            self.customAlert(title: "알림 권한 허용됨",
                                             message: "이미 알림권한이 허용되었습니다.")
                        }
                    }
                }
            })
            
            section.footerTitle = "로플랫 SDK를 사용하기 위해서는 위치 권한(항상 허용)은 필수로 필요하며, 알림 권한은 Gravity를 사용할 경우에 필요로 합니다. 권한 허용 API는 MiniPlengi에서는 제공하고 있지 않기에, 직접 구현하거나, developers.loplat.com을 참조해주세요."
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOTextTableViewCell(title: "에코 코드", key: "echo_code") {
                let cell = $0 as! BOTextTableViewCell
                cell.textField.placeholder = "echo_code"
            })
            
            section.addCell(BOButtonTableViewCell(title: "SDK 초기화", key: "init") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    guard let echo_code = UserDefaults.standard.string(forKey: "echo_code") else {
                        self.customAlert(title: "필수 항목이 누락되었습니다.",
                                         message: "에코 코드를 입력해주세요.")
                        return
                    }
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    guard appDelegate.initPlengi(echoCode: echo_code) else {
                        return
                    }
                    self.registerPlaceEngineDelegate()
                    Plengi.isDebug = true
                }
            })
            
            section.footerTitle = "echo code를 입력한 후, SDK 초기화 버튼을 누르세요"
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOButtonTableViewCell(title: "SDK 시작", key: "start") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    self.startSDK()
                }
            })
            
            section.addCell(BOButtonTableViewCell(title: "SDK 정지", key: "stop") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    self.stopSDK(alert: true)
                }
            })
            
            section.footerTitle = self.engineStatusMessage
            self.engineStatusSection = section
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOButtonTableViewCell(title: "장소 요청 (refreshPlace)", key: "refreshPlace") {
                let cell = $0 as! BOButtonTableViewCell
                cell.actionBlock = {
                    self.refreshPlace()
                }
            })
            
            section.footerTitle = "해당 기능은 테스트 용도로만 사용되어야만 하며, 릴리즈 앱에서는 사용하지 마세요."
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOSwitchTableViewCell(title: "Gravity 사용", key: "enable_gravity") {
                let cell = $0 as! BOSwitchTableViewCell
                cell.toggleSwitch.addTarget(self, action: #selector(self.enableGravity(sender:)), for: .valueChanged)
            })
            
            section.footerTitle = "로플랫 광고 (Gravity)를 사용할 수 있습니다."
        })
        
        self.addSection(BOTableViewSection.init(headerTitle: "") {
            let section = $0!
            section.addCell(BOSwitchTableViewCell(title: "사용자 마케팅 동의", key: "marketingAgreement") { cell in
            })
            section.addCell(BOSwitchTableViewCell(title: "사용자 위치정보 동의", key: "locationAgreement") { cell in
            })
            
            section.footerTitle = "사용자 동의 여부에 따른 시나리오를 확인합니다."
            
            section.cells.forEach {
                let cell = $0 as! BOSwitchTableViewCell
                // 주석을 제거하면 앱 첫 설치시 기본값이 true가 됩니다.
//                if nil == UserDefaults.standard.object(forKey: cell.key) {
//                    cell.setting.value = NSNumber(booleanLiteral: true)
//                }
                cell.toggleSwitch.addTarget(self, action: Selector((cell.key + "WithSender:")), for: .valueChanged)
            }
        })
    }
    
    /// 로플랫 SDK에 Delegate를 등록합니다.
    /// `Plengi.setDelegate` 메소드는 반환값이 있으며, 등록 성공 시 `Result.SUCCESS`가, 실패 시 `Result.FAIL` 이 반환됩니다.
    private func registerPlaceEngineDelegate() {
        guard Plengi.setDelegate(self) == .SUCCESS else {
            self.customAlert(title: "초기화에 실패하였습니다.",
                             message: "Plengi.setDelegate() 메소드에서 FAILED를 반환했습니다.")
            return
        }
    }
    
    /// 로플랫 SDK를 시작합니다.
    private func startSDK() {
        defer {
            self.reloadStatusSectionFooter()
        }
        guard self.locationAgreement else {
            self.customAlert(title: "SDK를 시작할 수 없음",
                             message: "사용자 위치정보 동의가 필요합니다.")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            self.customAlert(title: "SDK를 시작할 수 없음",
                             message: "위치 권한이 필요합니다.")
        }
        
        guard Plengi.start() == .SUCCESS else {
            self.customAlert(title: "SDK를 시작할 수 없음",
                             message: "초기화, iOS버전 등을 확인해보세요.")
            return
        }
    }
    
    /// 로플랫 SDK를 정지합니다.
    private func stopSDK(alert: Bool) {
        defer {
            self.reloadStatusSectionFooter()
        }
        guard Plengi.stop() == .SUCCESS else {
            if alert {
                self.customAlert(title: "SDK를 중단할 수 없음", message: "초기화, iOS버전 등을 확인해보세요.")
            }
            return
        }
        
    }
    
    private func reloadStatusSectionFooter() {
        self.engineStatusSection.footerTitle = self.engineStatusMessage
        self.tableView.reloadData()
    }
    
    /// 장소 인식 요청을 수동으로 호출합니다.
    /// 경고 : 실제 릴리즈 앱에서는 해당 기능을 사용하지 마세요. 테스트 용도로만 사용해주세요.
    private func refreshPlace() {
        guard Plengi.manual_refreshPlace_foreground() == .SUCCESS else {
            self.customAlert(title: "장소 요청을 할 수 없음", message: "초기화, iOS버전 등을 확인해보세요.")
            return
        }
    }
    
    func customAlert(title: String,
                     message: String,
                     action: String = "확인",
                     cancel: String? = nil,
                     handler: (() -> Void)? = nil) {
        let popupDialog = PopupDialog(title: title, message: message)
        
        if let cancel = cancel {
            popupDialog.addButton(CancelButton(title: cancel,
                                               action: nil))
        }
        
        popupDialog.addButton(DefaultButton(title: action,
                                            action: {
                                                if let handler = handler {
                                                    handler()
                                                }
        }))
        
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    @objc func enableGravity(sender: UISwitch) {
        DispatchQueue.main.async {
            defer {
                _ = Plengi.enableAdNetwork(self.enableGravity)
            }
            guard sender.isOn == false || self.marketingAgreement else {
                self.enableGravity = false
                self.customAlert(title: "Gravity를 사용할 수 없음", message: "사용자 마케팅 동의가 필요합니다.")
                return
            }
            if #available(iOS 10, *) {
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {
                    guard $0.authorizationStatus == .authorized else {
                        self.enableGravity = false
                        self.customAlert(title: "Gravity를 사용할 수 없음", message: "알림 권한이 필요합니다.")
                        return
                    }
                })
            }
            else {
                guard UIApplication.shared.isRegisteredForRemoteNotifications else {
                    self.enableGravity = false
                    self.customAlert(title: "Gravity를 사용할 수 없음", message: "알림 권한이 필요합니다.")
                    return
                }
            }
        }
    }
    
    @objc func marketingAgreement(sender: UISwitch) {
        defer {
            _ = Plengi.enableAdNetwork(self.enableGravity)
        }
        guard self.enableGravity == false || self.marketingAgreement else {
            self.enableGravity = false
            self.customAlert(title: "Gravity를 사용할 수 없음", message: "Gravity 기능을 끕니다.")
            return
        }
    }
    
    @objc func locationAgreement(sender: UISwitch) {
        guard self.locationAgreement || Plengi.getEngineStatus() == .STOPPED else {
            self.stopSDK(alert: false)
            self.customAlert(title: "SDK를 사용할 수 없음", message: "SDK를 중단합니다.")
            return
        }
    }
}
