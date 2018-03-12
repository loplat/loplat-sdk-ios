//
//  PermissionDataModel.swift
//  loplat PlengiTools
//
//  Created by 상훈 on 20/02/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import Foundation

import Sparrow

class PermissionDataModel: SPRequestPermissionDialogInteractiveDataSource {
    override func headerTitle() -> String {
        return "잠깐!"
    }
    
    override func headerSubtitle() -> String {
        return "아래의 권한을 허용해주세요!"
    }
    
    override func topAdviceTitle() -> String {
        return "아래의 권한이 허용되어야만\n앱을 실행할 수 있습니다!"
    }
    
    override func bottomAdviceTitle() -> String {
        return "해당 권한은 시스템 설정에서 변경할 수 있습니다."
    }
    
    override func underDialogAdviceTitle() -> String {
        return ""
    }
    
    override func titleForAlertDenidPermission() -> String {
        return "권한 거부됨"
    }
    
    override func subtitleForAlertDenidPermission() -> String {
        return "권한이 거부되었습니다.\n설정으로 이동하여 권한을 허용해주세요."
    }
    
    override func cancelForAlertDenidPermission() -> String {
        return "확인"
    }
    
    override func settingForAlertDenidPermission() -> String {
        return "설정으로 이동"
    }
    
    override func titleForPermissionControl(_ permission: SPRequestPermissionType) -> String {
        var title = String()
        switch permission {
        case .camera:
            title = "카메라 사용권한 허용하기"
        case .photoLibrary:
            title = "사진 접근 권한 허용하기"
        case .notification:
            title = "알림 허용하기"
        case .microphone:
            title = "마이크 허용하기"
        case .calendar:
            title = "캘린더 정보접근 허용하기"
        case .locationWhenInUse:
            title = "위치권한 허용하기"
        case .locationAlways:
            title = "위치권한(항상) 허용하기"
        case .locationWithBackground:
            title = "위치권한(백그라운드) 허용하기"
        case .contacts:
            title = "연락처 정보 사용 허용하기"
        case .reminders:
            title = ""
        }
        return title
    }
}
