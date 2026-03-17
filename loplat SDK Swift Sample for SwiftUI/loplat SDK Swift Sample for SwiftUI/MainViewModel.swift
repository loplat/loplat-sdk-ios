//
//  MainViewModel.swift
//  loplat SDK Swift Sample for SwiftUI
//

import Foundation
import CoreLocation
import AppTrackingTransparency
import UserNotifications
import MiniPlengi

class MainViewModel: NSObject, ObservableObject {
    private let locationLogsKey = "locationLogs"
    private let onboardingKey = "needShowOnboarding"
    
    // MARK: - 온보딩

    @Published var needShowOnboarding: Bool

    func confirmOnboarding() {
        needShowOnboarding = false
        UserDefaults.standard.set(false, forKey: onboardingKey)
    }

    // MARK: - 권한

    @Published var currentLocationPermission: CLAuthorizationStatus = .notDetermined
    @Published var currentATTPermission: ATTrackingManager.AuthorizationStatus = .notDetermined
    @Published var currentNotificationPermission: Bool? = nil

    private let locationManager = CLLocationManager()

    var canRequestLocation: Bool { currentLocationPermission == .notDetermined }
    var canRequestATT: Bool { currentATTPermission == .notDetermined }
    var canRequestNotification: Bool { currentNotificationPermission == nil }

    var currentLocationString: String {
        switch currentLocationPermission {
        case .notDetermined: return "요청"
        case .denied, .restricted: return "거부"
        case .authorizedAlways: return "항상 허용"
        case .authorizedWhenInUse: return "앱 사용 중 허용"
        @unknown default: return "@unknown"
        }
    }

    var currentATTString: String {
        switch currentATTPermission {
        case .notDetermined: return "요청"
        case .authorized: return "허용"
        case .denied, .restricted: return "거부"
        @unknown default: return "@unknown"
        }
    }

    var currentNotificationString: String {
        switch currentNotificationPermission {
        case nil: return "요청"
        case .some(let granted): return granted ? "허용" : "거부"
        }
    }

    func requestLocationPermission() {
        /*
         앱의 시나리오에 따라 Core Location API를 사용하려는 경우(ex: 로그인 이후, 포그라운드에서 항상 허용 권한을 묻고싶은 경우.)
         Core Location API 문서를 참고하여 요청해주세요.
         */
        Plengi.requestAlwaysLocationAuthorization()
    }

    func requestATTPermission() {
        /*
         간헐적으로 추적허용 팝업이 뜨지 않는 문제를 피하기 위해 반드시 메인스레드 안에서 추적허용 권한을 요청해주세요.
         */
        Plengi.requestTrackingAuthorization {
            DispatchQueue.main.async {
                self.currentATTPermission = ATTrackingManager.trackingAuthorizationStatus
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.currentNotificationPermission = granted
            }
        }
    }

    // MARK: - SDK

    @Published var sdkStarted: Bool = false

    var sdkVersion: String { Plengi.getSdkVersion() ?? "None" }

    func startSDK() {
        // !!!: 앱 시작 혹은 로그인 할 때 마다 사용자의 위치약관동의 여부를 매번 확인해서 start를 호출해줘야만 합니다.
        let result = Plengi.start()
        guard result == .SUCCESS else {
            print("[SDK] start 실패: \(result)")
            return
        }
        sdkStarted = true
    }

    func stopSDK() {
        // !!!: 예외적인 케이스에 대해서 stop을 호출하지 마세요. stop은 사용자의 위치약관동의에 대한 거부 등 위치 수집이 중단되어야 할 때만 호출해주세요.
        let result = Plengi.stop()
        guard result == .SUCCESS else {
            print("[SDK] stop 실패: \(result)")
            return
        }
        sdkStarted = false
    }

    func refreshStatus() {
        sdkStarted = Plengi.getEngineStatus() == .STARTED
        currentATTPermission = ATTrackingManager.trackingAuthorizationStatus
        currentLocationPermission = locationManager.authorizationStatus

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined: self.currentNotificationPermission = nil
                case .authorized: self.currentNotificationPermission = true
                default: self.currentNotificationPermission = false
                }
            }
        }
    }

    // MARK: - 위치 로그

    @Published var locationLogs: [LocationLog] = []

    func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
        guard plengiResponse.result == .SUCCESS else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())

        let name = plengiResponse.place?.name ?? "알 수 없는 장소"
        let address = plengiResponse.place?.address ?? ""
        let latitude = plengiResponse.location?.lat ?? 0.0
        let longitude = plengiResponse.location?.lng ?? 0.0

        let log = LocationLog(
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp
        )

        print(log)

        DispatchQueue.main.async {
            self.locationLogs.insert(log, at: 0)
            self.saveLogs()
        }

        sendPlaceNotification(log: log)
    }

    private func sendPlaceNotification(log: LocationLog) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("[Notification] 권한 없음: \(settings.authorizationStatus.rawValue)")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = log.name
            content.body = "\(log.timestamp)  \(String(format: "%.4f", log.latitude)), \(String(format: "%.4f", log.longitude))"
            content.sound = .default
            content.userInfo = [
                "latitude": log.latitude,
                "longitude": log.longitude
            ]

            let request = UNNotificationRequest(
                identifier: log.id.uuidString,
                content: content,
                trigger: nil // 즉시 발송
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("[Notification] 발송 실패: \(error)")
                } else {
                    print("[Notification] 발송 성공: \(log.name)")
                }
            }
        }
    }

    // MARK: - Init

    override init() {
        if UserDefaults.standard.object(forKey: "needShowOnboarding") == nil {
            needShowOnboarding = true
        } else {
            needShowOnboarding = UserDefaults.standard.bool(forKey: "needShowOnboarding")
        }
        
        super.init()
        
        locationManager.delegate = self
        loadLogs()
    }

    // MARK: - UserDefaults

    private func loadLogs() {
        guard
            let data = UserDefaults.standard.data(forKey: locationLogsKey),
            let logs = try? JSONDecoder().decode([LocationLog].self, from: data)
        else { return }
        locationLogs = logs
    }

    private func saveLogs() {
        guard let data = try? JSONEncoder().encode(locationLogs) else { return }
        UserDefaults.standard.set(data, forKey: locationLogsKey)
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.currentLocationPermission = manager.authorizationStatus
        }
    }
}
