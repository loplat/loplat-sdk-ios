//
//  AppDelegate+PlaceDelegate.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//
import MiniPlengi

extension Notification.Name {
    public static let pr = NSNotification.Name("plengiResponse")
}

extension AppDelegate: PlaceDelegate {
    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        
        /*
         여기서 UserDefaults에 PlengiResponse 데이터 저장 후, Notification 전송
         */
        let plengiResponseData = NSKeyedArchiver.archivedData(withRootObject: plengiResponse)
        
        UserDefaults.standard.set(plengiResponseData, forKey: "plengiResponse")
        
        NotificationCenter.default.post(name: .pr, object: nil)
    }
    
}

