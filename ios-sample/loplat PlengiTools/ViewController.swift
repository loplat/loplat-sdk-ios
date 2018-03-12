//
//  ViewController.swift
//  loplat PlengiTools
//
//  Created by 상훈 on 20/02/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import Foundation

import UIKit
import SystemConfiguration
import AdSupport.ASIdentifierManager

import Sparrow
import CircleMenu
import SnapKit
import PopupDialog
import MiniPlengi

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: 1.0 / 255.0 * CGFloat(red),
            green: 1.0 / 255.0 * CGFloat(green),
            blue: 1.0 / 255.0 * CGFloat(blue),
            alpha: CGFloat(alpha))
    }
}

//
// Plengi 인스턴스는 AppDelegate와 연결되어 있기 때문에, 해당 샘플앱에서는 Broadcast 형태(Notification) 으로 메소드를 호출하고, 정보를 가져오는 형식으로 사용합니다.
// let appDelegate = UIApplication.shared.delegate as! AppDelegate 를 사용하여 접근해도 상관 없습니다.
//

class ViewController: UIViewController, CircleMenuDelegate, SPRequestPermissionEventsDelegate {
    
    @IBOutlet private weak var circleButton: CircleMenu!
    
    private var isScanButtonClicked = false
    
    private var isInit = false
    
    let items: [(icon: String, color: UIColor)] = [
        ("icon_search", UIColor(red: 0.22, green: 0.6, blue: 1, alpha: 1)),
        ("icon_wifi", UIColor(red: 219.0 / 255.0, green: 46.0 / 255.0, blue: 106.0 / 255.0, alpha: 1)),
        ("icon_bluetooth", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*circleButton.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveCurrentPlace(_:)), name: NSNotification.Name(rawValue: "receiveCurrentPlace"), object: nil) // AppDelegate에서 receiveCurrentPlace 라는 이벤트를 송신했을때, 해당 클래스 ViewController에서 receiveCurrentPlace 이벤트를 수신합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveBLStatus(_:)), name: NSNotification.Name(rawValue: "receiveBLStatus"), object: nil)  // AppDelegate에서 receiveBLStatus 라는 이벤트를 송신했을때, 해당 클래스 ViewController에서 receiveBLStatus 이벤트를 수신합니다.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.navigationItem.title = "홈"
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        
        if !isInit {
            isInit = true
            if !SPRequestPermission.isAllowPermissions([.locationAlways, .notification]) {
                SPRequestPermission.dialog.interactive.present(on: self, with: [.locationAlways, .notification], dataSource: PermissionDataModel(), delegate: self)
            } else {
                let title = "Gravity 광고 알림"
                let message = "Gravity 광고를 사용합니다."
                
                openPopup(title: title, message: message, okButtonClickEvent: { () -> Void in
                    NotificationCenter.default.post(name: NSNotification.Name("initPlengi"), object: self) // AppDelegate가 수신하는 이벤트 "initPlengi" 를 해당 시점에서 송신합니다.
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ t: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        if atIndex == 0 {
            t.duration = 3.0
            NotificationCenter.default.post(name: NSNotification.Name("refreshLocation"), object: self) // AppDelegate가 수신하는 이벤트 "refreshLocation" 을 해당 시점에서 송신합니다.
            isScanButtonClicked = true
        } else if atIndex == 1 {
            t.duration = 0.5
        } else if atIndex == 2 {
            t.duration = 1.0
        }
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        if atIndex == 1 {
            let ssid = PlengiNetworkInterfaceManager.getNetworkSSID()
            let bssid = PlengiNetworkInterfaceManager.getNetworkBSSID()
            
            var title = "연결됨 : \(ssid)"
            var message = "고유번호 > \(bssid)"
            
            if ssid == "연결 안됨" {
                title = "와이파이에 연결되어 있지 않음"
                message = "와이파이에 연결되어 있지 않습니다.\n오류 : Could not access network interfaces."
            }
            
            openPopup(title: title, message: message, okButtonClickEvent: { () -> Void in
                
            })
        } else if atIndex == 2 {
            NotificationCenter.default.post(name: NSNotification.Name("checkBLE"), object: self)
        }
    }
    
    @objc func receiveCurrentPlace(_ notification: NSNotification) {
        if isScanButtonClicked {
            let userinfo = notification.userInfo as! [AnyHashable: Any]
            
            let placename = userinfo["placename"] as! String
            let subname = userinfo["subname"] as! String
            let floor = userinfo["floor"] as! Int
            let address = userinfo["address"] as! String
            let storeid = userinfo["placeid"] as! Int
            let accuracy = userinfo["accuracy"] as! Double
            
            if placename == "위치 인식 실패" {
                openPopup(title: "위치 인식 실패", message: "현재 위치를 식별할 수 없습니다.\n오류 : Location Acquisition Fail", okButtonClickEvent: { () -> Void in
                    
                })
            } else {
                var title = "\(placename) \(subname) (\(floor)F)"
                var message = "\(address)\n\nStore ID : \(storeid)\n정확도 : \(roundToPlaces(calc: accuracy * 100.0, places: 2))%"
                
                openPopup(title: title, message: message, okButtonClickEvent: { () -> Void in
                    
                })
            }
            
            isScanButtonClicked = false
        }
    }
    
    @objc func receiveBLStatus(_ notification: NSNotification) {
        let userInfo = notification.userInfo as! [AnyHashable: Any]
        
        let isBLEnabled = userInfo["isEnabled"] as! Bool
        
        if isBLEnabled {
            openPopup(title: "블루투스가 이미 켜져있음", message: "블루투스가 켜져있으므로, 장소 검색 / Gravity 사용시 BLE 스캔을 사용합니다.", okButtonClickEvent: { () -> Void in
                
            })
        }
    }
    
    func didHide() {
        if !SPRequestPermission.isAllowPermissions([.locationAlways, .notification]) {
            openPopup(title: "권한 오류", message: "필수로 필요한 권한이 허용되지 않았습니다.\n앱을 종료합니다.", okButtonClickEvent: { () -> Void in
                exit(0)
            })
        }
    }
    
    func didAllowPermission(permission: SPRequestPermissionType) {
        if SPRequestPermission.isAllowPermissions([.locationAlways, .notification]) {
            NotificationCenter.default.post(name: NSNotification.Name("initPlengi"), object: self)
        }
    }
    
    func didDeniedPermission(permission: SPRequestPermissionType) {
        
    }
    
    func didSelectedPermission(permission: SPRequestPermissionType) {
        
    }
    
    func openPopup(title: String, message: String, okButtonClickEvent: @escaping () -> Void) {
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                gestureDismissal: true,
                                hideStatusBar: false) {
                                    
        }
        
        let buttonOne = DefaultButton(title: "확인") {
            defer {
                okButtonClickEvent()
            }
        }
        
        popup.addButtons([buttonOne])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func roundToPlaces(calc: Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(calc * divisor) / divisor
    }
}

