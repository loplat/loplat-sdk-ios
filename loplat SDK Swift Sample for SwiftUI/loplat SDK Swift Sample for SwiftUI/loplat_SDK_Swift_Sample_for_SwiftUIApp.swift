//
//  loplat_SDK_Swift_Sample_for_SwiftUIApp.swift
//  loplat SDK Swift Sample for SwiftUI
//
//  Created by Soohyeon Lee on 2/2/26.
//

import SwiftUI
import UserNotifications
import MiniPlengi

@main
struct loplat_SDK_Swift_Sample_for_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: delegate.viewModel)
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    let viewModel = MainViewModel()

    // Plengi 초기화 및 Delegate 설정
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
         // !!!: Plengi.initialize() 함수는 반드시 AppDelegate 안의 application(_:didFinishLaunchingWithOptions:) 에서 호출되어야 합니다.
         // !!!: 다른곳에서 호출할 경우, SDK가 작동하지 않습니다.

        let clientID = "loplatdemo"         // 로플랫에서 발급받은 클라이언트 아이디
        let clientSecret = "loplatdemokey"     // "로플랫에서 발급받은 클라이언트 키"

        if Plengi.initialize(clientID: clientID, clientSecret: clientSecret) == .SUCCESS {
            // init 성공

            // echo_code는 로플랫과 데이터 연동시 고객사에서 분석과 조회하기 위한 사용자 식별 코드입니다.
            // 이 코드는 로플랫에서 저장하지도 활용하지도 않으며 오직 고객사에 전달하는 데이터에만 포함됩니다.
            // 설정하지 않아도 SDK는 작동합니다.
            // !!!: 이메일, 전화번호와 같은 개인정보 혹은 광고ID(ADID, IDFA)를 전달하지 마세요.
            let echoCode = "echoCode" // 고객사 별 사용자를 식별할 수 있는 코드 (개인정보 주의바람)
            if Plengi.setEchoCode(echoCode: echoCode) == .SUCCESS {
                // echoCode 등록 성공
            } else {
                // echoCode 등록 실패
            }

            // 아래의 경우에 이벤트를 수신하길 원하신다면 PlaceDelegate를 등록해야합니다.
            // 1. 서버로부터 장소 인식 이벤트를 받았을 때
            // 2. loplat X 광고 수신이 되었을 때
            // 설정하지 않아도 SDK는 작동합니다.
            if Plengi.setDelegate(self) == .SUCCESS {
                // delegate 등록 성공
            } else {
                // delegate 등록 실패
            }
        } else {
            // init 실패
        }

        // foreground에서도 알림이 표시되도록 delegate를 설정합니다.
        UNUserNotificationCenter.current().delegate = self

        return true
    }
}

// MARK: - AppDelegate + PlaceDelegate

extension AppDelegate: PlaceDelegate {
    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        print("PlengiResponse: \(plengiResponse)")

        if let _ = plengiResponse.echoCode {
            // 고객사에서 설정한 echoCode
        }

        if plengiResponse.result == .SUCCESS {
            if plengiResponse.place != nil {
                if plengiResponse.placeEvent == .ENTER {
                    // PlaceEvent가 ENTER 일 경우, 들어온 장소 정보 객체가 넘어옴
                } else if plengiResponse.placeEvent == .NEARBY {
                    // PlaceEvent가 NEARBY 일 경우, NEARBY 로 인식된 장소 정보가 넘어옴
                }
            }
            if plengiResponse.complex != nil {
                // 복합몰이 인식되었을 때
            }
            if plengiResponse.area != nil {
                // 상권이 인식되었을 때
            }
            if plengiResponse.advertisement != nil {
                // loplat X 광고 정보가 있을 때
                // 기본으로 Plengi SDK에서 광고이벤트를 직접 알림으로 처리합니다.
                // 하지만 설정값에 따라 광고이벤트를 직접 처리할 경우 해당 객체를 사용합니다.
            }
            if plengiResponse.geofence != nil {
                // Geofence 정보가 있을 때
            }
            if plengiResponse.location != nil {
                // 인식할 때의 기기의 위경도 값
            }
            if plengiResponse.district != nil {
                // 행정구역 (District) 정보가 있을 때
            }
        } else {
            /* 여기서부터는 오류인 경우입니다 */
            // plengiResponse.errorReason 에 위치 인식 실패 / 오류 이유가 포함됨
            // FAIL : 위치 인식 실패
            // NETWORK_FAIL : 네트워크 오류
            // ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
        }
        
        viewModel.responsePlaceEvent(plengiResponse)
    }
}

// MARK: - AppDelegate + UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.sound, .badge, .banner]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let latitude = userInfo["latitude"] as? Double,
           let longitude = userInfo["longitude"] as? Double {
            // 샘플 앱 사용자 편의를 위한 Local Notification 로직입니다.
            let urlString = "https://www.google.com/maps/place/\(latitude),\(longitude)"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        /*
         아래의 메소드를 적용해주시면 loplat X와 연계된 캠페인 메시지를 받으실수 있습니다.
         해당 샘플앱에서는 loplat X 통합 관련 내용이 없습니다.
         자세한 내용은 https://developers.loplat.com/docs/ios/#loplat-x-%EC%97%B0%EB%8F%99%ED%95%98%EA%B8%B0 을 참조해주세요.
         */
        // _ = Plengi.processLoplatAdvertisement(center, didReceive: response, withCompletionHandler: completionHandler)

        completionHandler()
    }
}
