//
//  AppDelegate+PlaceDelegate.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//
import MiniPlengi

extension AppDelegate: PlaceDelegate {
    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        var title = "Plengi Response : "
        var message = ""
        if let echoCode = plengiResponse.echoCode {
            message += "Echo code : " + echoCode
        }
        
        defer {
            DispatchQueue.main.async {
                if let topMostViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
                    let alert = UIAlertController.init(title: title,
                                                       message: message,
                                                       preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "확인",
                                                    style: .default) { action in
                                                        alert.dismiss(animated: true,
                                                                      completion: nil)
                    }
                    alert.addAction(action)
                    topMostViewController.present(alert,
                                                  animated: true,
                                                  completion: nil)
                }
            }
        }
        
        // 위치 인식이 성공했을 때
        if plengiResponse.result == .SUCCESS {
            if let place = plengiResponse.place {
                title += place.name
                message = "\nplaceEvent : "
                if plengiResponse.placeEvent == .ENTER {
                    // PlaceEvent가 NEARBY 일 경우, NEARBY 로 인식된 장소 정보가 넘어옴\
                    message += "ENTER"
                } else if plengiResponse.placeEvent == .NEARBY {
                    // PlaceEvent가 ENTER 일 경우, 들어온 장소 정보 객체가 넘어옴
                    message += "NEARBY"
                } else if plengiResponse.placeEvent == .LEAVE {
                    // PlaceEvent가 LEAVE 일 경우, 떠난 장소 정보 객체가 넘어옴
                    message += "LEAVE"
                }
                message += "\nID : \(place.loplat_id) \nAddress_road : " + place.address_road
            }
            // 복합몰이 인식되었을 때
            if let complex = plengiResponse.complex {
                title += complex.name
                message = "\nID : \(complex.id) \nBranch name: " + complex.branch_name
            }
            // 상권이 인식되었을 때
            if let area = plengiResponse.area {
                title += area.name
                message = "\nID : \(area.id) \nlat : \(area.lat) \nlng : \(area.lng)"
            }
            // 행정구역이 인식되었을 때
            if let district = plengiResponse.district {
                title += "\(district.lv1_name) \(district.lv2_name) \(district.lv3_name)"
            }
            // 인식했을 당시 기기의 위경도 정보
            if let location = plengiResponse.location {
                title += "디바이스 위경도"
                message = "\nlat : \(location.lat) \nlng : \(location.lng)"
            }
        } else {
            guard let errorReason = plengiResponse.errorReason else {
                // 오류 원인이 nil 이라면, 최종적으로 오류라고 판단한다
                title += "Error"
                message = "\nReason : " + (plengiResponse.errorReason ?? "Unknown")
                return
            }
            
            // 오류 원인이 '위치 인식 실패 (Location Acquuisition Fail)' 일 경우
            if plengiResponse.result == .FAIL && errorReason == "Location Acquisition Fail" {
                // 위치 인식은 실패했어도 기기 위경도는 있다
                if let location = plengiResponse.location {
                    title += "디바이스 위경도"
                    message = "\nlat : \(location.lat) \nlng : \(location.lng)"
                }
            }
        }
    }
}
