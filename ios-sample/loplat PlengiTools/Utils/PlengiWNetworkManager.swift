//
//  PlengiWNetworkManager.swift
//  loplat PlengiTools
//
//  Created by 상훈 on 23/02/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import Foundation

import UIKit

class PlengiWNetworkManager {
    public static func getWiFiRSSI() -> Int? {
        let app = UIApplication.shared
        var rssi: Int?
        let exception = tryBlock {
            guard let statusBar = app.value(forKey: "statusBar") as? UIView else { return }
            if let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), statusBar .isKind(of: statusBarMorden) { return }
            
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return  }
            
            for view in foregroundView.subviews {
                if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view .isKind(of: statusBarDataNetworkItemView) {
                    if let val = view.value(forKey: "wifiStrengthRaw") as? Int {
                        rssi = val
                        break
                    }
                }
            }
        }
        if let exception = exception {
            print("getWiFiRSSI exception: \(exception)")
        }
        return rssi
    }

    public static func getWiFiRSSI_iPhoneX() -> Int? {
        let app = UIApplication.shared
        var numberOfActiveBars: Int?
        let exception = tryBlock {
            guard let containerBar = app.value(forKey: "statusBar") as? UIView else { return }
            guard let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), containerBar .isKind(of: statusBarMorden), let statusBar = containerBar.value(forKey: "statusBar") as? UIView else { return }
            
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return }
            
            for view in foregroundView.subviews {
                for v in view.subviews {
                    if let statusBarWifiSignalView = NSClassFromString("_UIStatusBarWifiSignalView"), v .isKind(of: statusBarWifiSignalView) {
                        if let val = v.value(forKey: "numberOfActiveBars") as? Int {
                            numberOfActiveBars = val
                            break
                        }
                    }
                }
                if let _ = numberOfActiveBars {
                    break
                }
            }
        }
        if let exception = exception {
            print("getWiFiNumberOfActiveBars exception: \(exception)")
        }
        
        return numberOfActiveBars
    }
    
    public struct Device {
        // iDevice detection code
        static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
        static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
        static let IS_RETINA           = UIScreen.main.scale >= 2.0
        
        static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
        static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
        static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
        static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
        
        static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
        static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
        static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
        static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
        static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    }
}
