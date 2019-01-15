//
//  MainViewController+PlaceDelegate.swift
//  loplat SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 12..
//  Copyright © 2018년 loplat. All rights reserved.
//

import MiniPlengi

extension MainViewController: PlaceDelegate {
    /// 로플랫 SDK에서 장소 인식 등 서버로부터 응답이 온 경우, 해당 Delegate가 호출됩니다.
    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        var title = "Plengi Response : "
        var message = ""
        if let echoCode = plengiResponse.echoCode {
            message += "Echo code : " + echoCode
        }
        
        defer {
            self.customAlert(title: title, message: message)
        }
        
        guard plengiResponse.result == .SUCCESS else {
            /* 여기서부터는 오류인 경우입니다 */
            // plengiResponse.errorReason 에 위치 인식 실패 / 오류 이유가 포함됨
            
            // FAIL : 위치 인식 실패
            // NETWORK_FAIL : 네트워크 오류
            // ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
            title += "Error"
            message += "\nReason : " + (plengiResponse.errorReason ?? "NONE")
            return
        }
        
        if let place = plengiResponse.place {
            title += place.name
            message += "\nplaceEvent : "
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
        else if let complex = plengiResponse.complex {
            title += complex.name
            message += "\nID : \(complex.id) \nBranch name: " + complex.branch_name
        }
            // 상권이 인식되었을 때
        else if let area = plengiResponse.area {
            title += area.name
            message += "\nID : \(area.id) \nlat : \(area.lat) \nlng : \(area.lng)"
        }
    }
}
