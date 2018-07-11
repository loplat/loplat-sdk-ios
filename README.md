﻿##### Plengi SDK (for iOS)

```loplat_caution
  loplat SDK 버전 1.0 미만 버전은 곧 서비스가 중단될 예정이오니,
  업데이트를 꼭 해주세요.
```

## Installation
### 프로젝트에 Plengi SDK 적용하기
#### Cocoapod 적용하기
- loplat SDK (Plengi SDK)를 사용하기 위해서는 Cocoapod 을 사용해야합니다. Cocoapod은 Mac/iOS 개발 프로젝트의 라이브러리 관리 도구이며, 쉽게 생각해서 안드로이드의 Gradle 같은 존재입니다. 프로젝트에 이미 Cocoapod 을 사용하고 있다면, 다음 단계 [프로젝트에 Cocoapod 사용하기](https://github.com/loplat/loplat-sdk-ios#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%EC%97%90-cocoapod-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0) 으로 넘어가세요.


#### Cocoapod 설치하기
- Cocoapod 바이너리를 설치합니다. 터미널에 아래의 명령어를 입력하세요.
	
	```bash
	$ sudo gem install cocoapods
	```


#### 프로젝트에 Cocoapod 사용하기
- 프로젝트에서 Cocoapod 모듈을 활성화합니다. 터미널에 아래의 명령어를 입력하세요.
	```bash
	$ cd $PROJECT_PATH
	$ pod init
	```
	이제 해당 XCode 프로젝트에서 Cocoapod을 사용할 준비가 완료되었습니다.


#### Cocoapod에 Plengi SDK 추가하기
- 위의 명령어를 실행하면 프로젝트 폴더에 **Podfile** 이라는 파일이 생성됩니다.
	Podfile을 텍스트 편집기로 열면 아래와 같은 형식의 내용이 등장합니다.
	```Podfile
	platform :ios, '8.0'
	# use_frameworks!

	target 'MyApp' do
	  pod 'AFNetworking', '~> 2.6'
	  pod 'ORStackView', '~> 3.0'
	  pod 'SwiftyJSON', '~> 2.3'
	end
	```

- 빌드 환경이 **iOS 기기일 경우**

	Podfile 의  target 태그안에
	```Podfile
	pod 'MiniPlengi', '1.1.2'
	```
	을 입력한 후, 저장합니다.

	**SDK가 Swift를 사용하기 때문에, Podfile에 `# uses_frameworks` 을 주석을 해제합니다. (#을 지우면 됨)**

#### Cocoapod 라이브러리 설치하기
- 아래의 명령어를 터미널에 입력하여 라이브러리를 적용합니다.
	
	```bash
	$ pod update
	$ pod install
	```

이제 라이브러리 적용 작업이 모두 완료되었습니다!!



### Cocoapod이 적용된 프로젝트 열기

Cocoapod이 적용된 프로젝트를 열기 위해서는 확장자가 **.xcodeproj** 를 열면 안되며, 워크스페이스 파일  **.xcworkspace** 파일을 열여야 합니다.


## SDK 사용하기

### 앱 권한 추가하기
#### 권한 추가하기
- Plengi SDK를 사용하기 위해서는 권한을 추가해야합니다. 필요한 권한은 아래와 같습니다.
	```xcode_permissions
	Background Modes 
	- Location Updates
	- Uses Bluetooth LE accessories
	- Background fetch

	Wireless Accessories Configuration
	```
	
	XCode 에서 **프로젝트 > Capabilities**에 들어가 위 권한 목록에 있는 권한들을 허용해줍니다.
	
	![XCode에서 권한 허용하기](https://storage.googleapis.com/loplat-storage/public/sdk-doc/ios_1.png)
	
	##### 권한을 사용하는 이유
	- Background Modes - Location Updates
		- 백그라운드에서도 위치 정보를 수신하기 위해 사용합니다.

	- Background Modes - Uses Bluetooth LE accessories
		- 백그라운드에서도 BLE를 스캔하여 위치 인식에 정확도를 향상하기 위해 사용합니다.

	- Bacoground Modes - Background fetch
		- 백그라운드에서 loplat 서버로부터 위치정보를 수신하기 위해 사용합니다.

	- Wireless Accessories Configuration
		- 백그라운드에서 BLE를 사용하기 위해 사용합니다.	

#### 위치 권한 사용 명시하기
iOS 11 이상부터 위치권한을 사용하기 위해서는 사용자에게 피드백 문구를 제공해야 합니다.
앱 상황에 맞는 문구를 추가하세요.
**(아래는 샘플이며, 샘플처럼 사유가 같을 경우 앱스토어에서 반려될 수 있습니다.)**
`info.plist` 파일에 아래 값을 추가합니다.

```xl
  <?xml version="1.0" encoding="UTF-8">
  <!DOCTYPE plist PUBLIC "=//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
	<!-- 중간 생략 -->
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>예 : 현재 위치를 판별하기 위해 위치정보를 사용합니다.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>예 : 현재 위치를 판별하기 위해 위치정보를 사용합니다.</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>예 : 현재 위치를 판별하기 위해 위치정보를 사용합니다.</string>
	<!-- 이하 생략 -->
  </dict>
  </plist>
```


위의 코드를 XCode에서 보면 아래와 같습니다.
![XCode info.plist](https://storage.googleapis.com/loplat-storage/public/sdk-doc/ios_2.png)


### import 하기
Objective-C를 사용하는 프로젝트와, Swift를 사용하는 프로젝트에서 loplat SDK를 적용하는 방법이 다릅니다.

#### 헤더파일 포함하기
`AppDelegate.h` (Objective-C) / `AppDelegate.swift` (Swift) 파일에, 아래의 구문을 추가해줍니다.
Gravity를 사용할 경우 UserNotificationsKit를 앱에 포함시켜야합니다.

```objectivec
  #import <MiniPlengi/MiniPlengi-Swift.h>
  #import <UserNotifications/UserNotifications.h> // Gravity를 사용할 경우
```

```swift
  import MiniPlengi
  import UserNotifications // Gravity를 사용할 경우
```


### PlaceDelegate, PlaceEngineDelegate 선언하기

- Objective-C

	`AppDelegate.h` 파일 클래스 선언부를 아래와 같이 수정합니다.
	
	```objectivec
	@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, PlaceDelegate, PlengiEngineDelegate>
	```
	
	`AppDelegate.m` 파일에 아래의 이벤트를 추가합니다.
	단, Gravity를 사용하지 않을 경우, 아래 2개의 이벤트 `userNotificationCenter` 는 생략할 수 있습니다.
	
	```objectivec
	@implementation AppDelegate

	// ********** 중간 생략 ********** //
	// loplat SDK가 정상적으로 초기화 되었을 때 이벤트
	- (void)isPlengiInitSuccessfully:(Plengi*)plengi {
		// plengi: 초기화 완료된 Plengi 객체를 쓰면 됨
		plengi.delegate = self;
	}

	// loplat SDK가 정상적으로 초기화 되지 않았을 때의 이벤트
	- (void)isPlengiInitFailed:(NSString*)result {
		// result : 초기화 실패 이유
	}

	- (void)responsePlaceEvent:(PlengiResponse *)plengiResponse {
		if ([plengiResponse result] == Result.SUCCESS) {
			if ([plengiResponse type] == ResponseType.PLACE_EVENT) {
				if ([plengiResponse place] != NULL) {
					if ([plengiResponse placeEvent] == PlaceEvent.ENTER) {
						// 사용자가 장소에 들어왔을 때
					} else if ([plengiResponse placeEvent] == PlaceEvent.NEARBY) {
						// NEARBY로 인식되었을 때
					} else if ([plengiResponse placeEvent] == PlaceEvent.LEAVE) {
						// 사용자가 장소를 떠났을 때
					}
				}

				if ([plengiResponse complex] != NULL) {
					// 복합몰이 인식되었을 때
				}

				if ([plengiResponse area] != NULL) {
					// 상권이 인식되었을 때
				}
			}
		} else {
			/* 여기서부터는 오류인 경우입니다 */
			// [plengiResponse errorReason] 에 위치 인식 실패 / 오류 이유가 포함됨

			// FAIL : 위치 인식 실패
			// NETWORK_FAIL : 네트워크 오류
			// ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
		}
	}
	
	// ********** 중간 생략 ********** //
	// ********** Gravity를 쓸 경우에만 아래 추가 ********** //
	// ********** iOS 10 이상에서 광고알림이 올 경우 처리하기 위한 이벤트 ********** //

	- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
		completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); 
		// iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)
	}

	- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
		[plengi processLoplatAdvertisement:center didReceive: response withCompletionHandler:completionHandler];
		completionHandler();
		// loplat SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리하기 위한 코드
	}
	@end
	```

- Swift

	`AppDelegate.swift` 파일 클래스 선언부를 아래와 같이 수정합니다.

	```swift
	class AppDelegate: UIResponder, UIApplicationDelegate, PlaceDelegate, PlengiEngineDelegate, UNUserNotificationCenterDelegate {
	```

	`AppDelegate.swift` 파일에 아래의 이벤트를 추가합니다.
	단, Gravity를 사용하지 않을 경우, 아래 2개의 이벤트 `userNotificationCenter` 는 생략할 수 있습니다.
	
	```swift
	func isPlengiInitSuccessfully(_ plengi: Plengi) {
		// plengi: 초기화 완료된 Plengi 객체를 쓰면 됨
		plengi.delegate = self
	}

	func isPlengiInitFailed(_ reason: String) {
		// result : 초기화 실패 이유
	}
	
	func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
		if plengiResponse.result == PlengiResponse.Result.SUCCESS {
			if plengiResponse.type == PlengiResponse.ResponseType.PLACE_EVENT { // BACKGROUND
				if plengiResponse.place != nil {
					if plengiResponse.placeEvent == PlengiResponse.PlaceEvent.ENTER {
						// PlaceEvent가 NEARBY 일 경우, NEARBY 로 인식된 장소 정보가 넘어옴
					} else if plengiResponse.placeEvent == PlengiResponse.PlaceEvent.NEARBY {
						// PlaceEvent가 ENTER 일 경우, 들어온 장소 정보 객체가 넘어옴
					} else if plengiResponse.placeEvent == PlengiResponse.PlaceEvent.LEAVE {
						// PlaceEvent가 LEAVE 일 경우, 떠난 장소 정보 객체가 넘어옴
					}
				}
	
				if plengiResponse.complex != nil {
					// 복합몰이 인식되었을 때
				}

				if plengiResponse.area != nil {
					// 상권이 인식되었을 때
				}
			}
		} else {
			/* 여기서부터는 오류인 경우입니다 */
			// [plengiResponse errorReason] 에 위치 인식 실패 / 오류 이유가 포함됨

			// FAIL : 위치 인식 실패
			// NETWORK_FAIL : 네트워크 오류
			// ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
		}
	}
	// ********** Gravity를 쓸 경우에만 아래 추가 ********** //

	@available(iOS  10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		plengi?.processLoplatAdvertisement(center, didReceive: response, withCompletionHandler: completionHandler)
		completionHandler()
		// loplat SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리하기 위한 코드
	}

	@available(iOS  10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .sound, .badge])
		// iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)
	}
	``` 


### PlaceEngine 초기화
Plengi (PlaceEngine)을 사용하기 위해 초기화 작업을 진행합니다.

```loplat_warning
  initPlaceEngine을 호출하면 PlengiEngineDelegate로 호출됩니다. 
  초기화가 완료될 경우 isPlengiInitSuccessfully 이벤트로 호출됩니다. 
  해당 이벤트로 넘어온 Plengi 객체를 사용하세요.
```

#### 1. 일반적인 초기화방법
- Objective-C
	`AppDelegate.m` 파일의 `application_didFinishLaunchingWithOptions` 이벤트에 아래의 코드를 추가합니다.
	```objectivec
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		// ********** 중간 생략 ********** //
		[Plengi initPlaceEngineWithClient_id:@"로플랫에서 발급받은 클라이언트 ID" client_secret:@"로플랫에서 발급받은 클라이언트 키" engineInitDelegate: self];
		// ********** 중간 생략 ********** //
	}
	``` 

- Swift
	`AppDelegate.swift` 파일의 `application_didFinishLaunchingWithOptions` 이벤트에 아래의 코드를 추가합니다.
	```swift
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [IOApplicationLaunchOptionsKey: Any]?) -> Bool {
		// ********** 중간 생략 ********** //
		Plengi.initPlaceEngine(client_id: "로플랫에서 발급받은 클라이언트 ID", client_secret: "로플랫에서 발급받은 클라이언트 키", engineInitDelegate: self)
		// ********** 중간 생략 ********** //
	}
	```


#### 2. Plengi 인스턴스를 `application_didFinishLaunchingWithOptions` 에서 호출하지 않았을 때
loplat SDK는 iOS 위치정보 업데이트 메소드 `startMonitoringSignificantLocationChanges` 를 통해 앱이 사용자에 의해 종료(Process Killed) 되었을 때에도 백그라운드로 다시 실행할 수 있는 코드가 내장되어 있습니다.

이 이벤트는 iOS에서 마지막으로 받은 위치에서 대략적으로 약 500m 차이가 나야만 발생하는 이벤트입니다. 즉, 사용자가 앱을 종료한 후, 사용자가 약 500m 정도 이동하면 시스템으로부터 해당 이벤트를 받아 앱이 백그라운드로 다시 살아나게 됩니다.

**`startMonitoringSignificantLocationChanges` 이벤트를 받았을 때, 시스템에서 `AppDelegate` 의 `application_didFinishLaunchingWithOptions` 메소드를 호출합니다. Plengi 인스턴스를 `application_didFinishLaunchingWithOptions` 에서 호출하지 않았을 때는 아래의 방식으로 꼭 초기화해주세요.**

`AppDelegate.m / AppDelegate.swift` 파일의 `application_didFinishLaunchingWithOptions` 메소드에 아래의 코드를 추가합니다.

- Objective-C
	```objectivec
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		// ********** 맨 위에다가 추가합니다. ********** //
		if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
			NSLog("App was restarted!"); // 디버깅용
			
			[Plengi initPlaceEngineWithClient_id:@"로플랫에서 발급받은 클라이언트 ID" client_secret:@"로플랫에서 발급받은 클라이언트 키" engineInitDelegate: self];
		}	
		// ********** 이하 생략 ********** //
	}
	```

- Swift
	```swift
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// ********** 맨 위에다가 추가합니다. ********** //
		if ((launchOptions?.index(forKey: UIApplicationLaunchOptionsKey.location)) != nil) {
			print("App was restarted!") // 디버깅용
			Plengi.initPlaceEngine(client_id: "로플랫에서 발급받은 클라이언트 ID", client_secret: "로플랫에서 발급받은 클라이언트 키", engineInitDelegate: self)
		}
		// ********** 이하 생략 ********** //
	}
	```

### PlengiResponse 객체
`PlaceDelegate` 에서 장소정보를 가지고 있는 객체입니다.
*`@objc` 키워드는 Objective-C에서도 동일하다는 의미입니다.*
*`let` 키워드는 변하지 않는 값이라는 것을 의미합니다.*

- Place

	```swift
	@objc public let loplat_id: Int						// 장소 ID
	@objc public let name: String						// 장소 이름
	@objc public let tags: String?						// 장소와 관련된 태그 (Nullable)
	@objc public let floor: Int							// 층 정보
	@objc public let lat: Double						// 장소의 위도
	@objc public let lng: Double						// 장소의 경도
	@objc public let accuracy: Double					// 정확도 (accuracy > threshold 비교 필요)
	@objc public let threshold: Double					// 한계치
	@objc public let client_code: String?				// 고객사 코드 (Nullable)
	@objc public let category: String					// 장소 카테고리
	@objc public let address: String?					// 장소 (구) 주소 (Nullable)
	@objc public let address_road: String?				// 장소 (도로명) 주소 (Nullable)
	@objc public let post: String?						// 장소 우편번호 (Nullable)
	```

- Area

	```swift
	@objc public let id: Int							// 상권 ID
	@objc public let name: String						// 상권 이름
	@objc public let tag: String						// 상권 지역
	@objc public let lat: Double						// 상권 위도
	@objc public let lng: Double						// 상권 경도
	```

- Complex

	```swift
	@objc public let id: Int					// 복합몰 ID
	@objc public let name: String				// 복합몰 이름
	@objc public let branch_name: String		// 복합몰 지점
	@objc public let category: String			// 복합몰 카테고리
	@objc public let category_code: String		// 복합몰 카테고리 코드
	```

	Place 객체에서 *accuracy > threshold* 여야만 Enter 이벤트입니다.
	저 조건이 맞지 않는경우 Near (옆에 있는 매장) 입니다.

### PlaceEngine 사용하기
#### Plengi 객체 접근하기
Plengi 객체를 호출하려면 plengi 변수를 저장할 수도 있지만, 아래의 인스턴스 코드를 통해 접근할 수 있습니다.

```loplat_warning
  initPlageEngine 을 통해 Plengi를 초기화하지 않았을 경우 nil(NULL)이 반환될 수 있습니다.
```

- Objective-C
	```objc
	[Plengi getInstance]
	```

- Swift
	```swift
	Plengi.getInstance()
	```

#### GPS 정확도 설정
loplat SDK가 위치를 확인할 때에 사용하는 GPS의 성능을 조정할 수 있습니다.

- Objective-C
	```objectivec
	plengi.gpsRecognitionType = PlengiGPSRecognitionLevelDEFAULT; 	// 기본값 (정확도 보통 (오차범위 1Km))
	plengi.gpsRecognitionType = PlengiGPSRecognitionLevelHIGH; 		// 권장 : 매우 높음(정확도 높음)
	plengi.gpsRecognitionType = PlengiGPSRecognitionLevelTHREE_KILLOMETER; // 반경 3km 오차발생 (배터리 소모량 매우 적음)
	```

- Swift
	```swift
	plengi?.gpsRecognitionType = .DEFAULT				// 기본값 (정확도 보통)
	plengi?.gpsRecognitionType = .HIGH					// 매우 높음 (정확도 높음, 배터리 소모량 증가)
	plengi?.gpsRecognitionType = .THREE_KILLOMETER		// 반경 3km 오차 발생 (배터리 소모량 매우 적음)
	```


#### 실내 인식 정확도 설정
loplat SDK가 위치를 인식할 때에 BLE를 사용할지 설정합니다.

**iOS의 정책에 따라 Wi-Fi 를 스캔할 수 있는 권한은 시스템만 존재하기 때문에, 기본값은 현재 연결되어있는 AP 정보, 위경도만을 가지고 파악합니다. BLE를 사용하면 SDK가 위치를 인식하는데에 같이 사용하기 때문에 정확도가 많이 향상됩니다.**

- Objective-C
	```objectivec
	plengi.recognitionType = PlengiLocationRecognitionLevelHigh;		// BLE 사용
	plengi.recognitionType = PlengiLocationRecognitionLevelNormal;		// BLE 사용 안함
	```

- Swift
	```swift
	plengi?.recognitionType = .High			// BLE 사용
	plengi?.recognitionType = .Normal		// BLE 사용 안함
	```


#### 블루투스가 꺼져있을 경우, 사용자에게 켜달라고 요청보내기

- Objective-C
	```objectivec
	[plengi requestBluetooth];
	```

- Swift
	```swift
	plengi?.requestBluetooth()
	```

#### 위치 권한 요청하기
- Objective-C
	```objectivec
	[plengi requestLocationPermission];
	```

- Swift
	```swift
	plengi?.requestLocationPermission()
	```

#### 위치 인식하기

- Objective-C
	```objectivec
	[plengi refreshLocation];
	```

- Swift
	```swift
	plengi?.refreshLocation()
	```

`refreshLocation` 메소드를 호출하면 `PlaceDelegate` 에 `responsePlaceEvent ` 이벤트가 호출됩니다.

#### 위치 트래킹하기
초단위로 사용자의 위치를 트래킹하여 사용자가 어느 위치에 있는지, 장소를 떠났는지, 새로운 장소에 도착했는지 알 수 있습니다.
- Objective-C
	```objectivec
	[plengi start:60]; // 60초에 한번씩 업데이트
	// (최소 주기는 60초 입니다. 주기가 짧으면 짧을수록, 배터리 사용량이 더 많아집니다.)
	```

- Swift
	```swift
	plengi?.start(60)	// 60초에 한번씩 업데이트
	// (최소 주기는 60초 입니다. 주기가 짧으면 짧을수록, 배터리 사용량이 더 많아집니다.)
	```

`start` 메소드를 사용할 경우 자동으로 백그라운드에서도 위치정보를 받아와 이벤트를 받을 수 있습니다.
백그라운드에서 이벤트를 받고싶지 않다면, `AppDelegate` 클래스에서 `applicationDidEnterBackground` 에서 `stop` 메소드를 사용하세요.

##### 위치 트래킹 중지하기
- Objective-C
	```objectivec
	[plengi stop];
	```

- Swift
	```swift
	plengi.stop()
	```

## Gravity 사용하기
### 권한 설정하기
#### 권한 요청하기
Gravity를 통해 푸시메시지를 받으려면, 사용자로부터 권한을 받아야합니다.
`AppDelegate.m` / `AppDelegate.swift` 파일에 아래와 같은 권한허용 코드를 추가합니다.
- Objective-C
	```objectivec
	@import UserNotifications;

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		// ********** 중간 생략 ********** //
		UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
		[center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) 
			completionHandler:^(BOOL granted, NSError * _Nullable error) {
			// 권한 허용되었을 때의 처리코드
		}
		
		[UNUserNotificationCenter currentNotificationCenter].delegate = self
		// ********** 이하 생략 ********** //
	}
	```

- Swift
	```swift
	import UserNotifications
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// ********** 중간 생략 ********** //
		if #available(iOS 10, *) {
			UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
			application.registerForRemoteNotifications()
		} else if #available(iOS 9, *) {
			UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
			UIApplication.shared.registerForRemoteNotifications()
		}

		if  #available(iOS  10.0, *) {
			UNUserNotificationCenter.current().delegate = self
		}
		// ********** 이하 생략 ********** //
	}
	```

#### Gravity 활성화하기
Gravity (loplat Ad.)를 사용하기 위해서는 SDK상에서 활성화 메소드를 실행해야합니다.
`AppDelegate.m` / `AppDelegate.swift` 파일에 `application_didFinishLaunchingWithOptions`메소드에 아래와 같은 코드를 추가합니다.
- Objective-C
	```objectivec
	[plengi enableAdWithIsEnabled:TRUE];
	[plengi registerLoplatAdvertisement];
	```

- Swift
	```swift
	plengi?.enableAd(isEnabled: true)
	plengi?.registerLoplatAdvertisement()
	```
**Gravity에서 푸시 알림을 받기 위해서는  `plengi.start()`  메소드를 사용하기 전에 저 위 2개의 메소드를 호출해주세요.**

##### Gravity 푸시알림 등록하기
Gravity (loplat Ad.) 푸시 알림을 사용자가 받기 위해서는 마지막 작업을 한번 더 해줘야 합니다.
`AppDelegate.m` / `AppDelegate.swift` 파일에 `application_handleActionWithIdentifier` 이벤트를 추가하고, 아래의 코드를 추가하세요.
- Objective-C
	```objectivec
	- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
		[plengi processLoplatAdvertisement:application handleActionWithIdentifier:identifier for:notification completionHandler:completionHandler];
	}

	- (void)applicationWillEnterForeground:(UIApplication *)application {
		[NSNotificationCenter.defaultCenter  postNotificationName:@"processAdvertisement"  object:nil];
	}

	- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void  (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {  
	completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);  // iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)  
	}  

	- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void  (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {  
		[plengi processLoplatAdvertisement:center didReceive: response withCompletionHandler:completionHandler]; 
		completionHandler();  // loplat SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리하기 위한 코드  
	}
	```

- Swift
	```swift
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
		plengi?.processLoplatAdvertisement(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "processAdvertisement"), object: nil) // SDK 내부 이벤트 호출 (정확한 처리를 위해 권장)
	}

	@available(iOS 10.0,  *) 
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ()  ->  Void) { 
		plengi?.processLoplatAdvertisement(center, didReceive: response, withCompletionHandler: completionHandler) 
		completionHandler()  // loplat SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리하기 위한 코드  
	} 

	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping  (UNNotificationPresentationOptions) -> Void) { 
		completionHandler([.alert,  .sound,  .badge])  // iOS 10 이상에서도 포그라운드에서 알림을 띄울 수 있도록 하는 코드 (가이드에는 뱃지, 소리, 경고 를 사용하지만, 개발에 따라 빼도 상관 무)  			
	}
	```

#### Gravity 비활성화하기
사용자가 푸시알림 동의를 하지 않을경우 등, 특정 시나리오에 따라 광고 수신을 허용하지 않을 경우, 아래의 메소드를 호출하여 Gravity 사용을 중지합니다.
- Objective-C
	```objectivec
	[plengi enableAdWithIsEnabled:FALSE];
	```

- Swift
	```swift
	plengi?.enableAd(isEnabled: false)
	```


(샘플앱을 참조하세요. https://github.com/loplat/loplat-sdk-ios)
**(현재 샘플앱은 Swift용으로 되어 있습니다. 동작확인은 Swift용으로 해주세요. Objective-C용 샘플앱은 리빌딩 중이오니, 업로드 할 예정입니다.)**
(샘플앱도 Cocoapod을 사용합니다. Cocoapod 사용법은 위에 명시되어 있습니다.)

## History
#### 2018. 07. 12.
- iOS SDK Version 1.1.2
		- 빌드 시 CommonCrypto/CommonCrypto.h 링크 오류 수정

#### 2018. 06. 26.
- iOS SDK Version 1.1.1
		- PlengiEngineDelegate 추가 (안전한 Plengi 초기화)
		- XCode 내부 도큐먼트 추가
		- Plengi.init 내부 로직 변경 (BLE 메타데이터 다운로드 부분)
		- Complex에서 지점명이 없는 곳에 방문했을 경우, SDK가 죽는 버그 수정
		- start(), stop() 메소드에 성공, 실패여부를 반환하도록 추가
		- 위치 권한 요청 API 추가

#### 2018. 06. 07.
- iOS SDK Version 1.1.0
		- PlaceDelegate를 하나로 간소화 (안드로이드와 동일하게 변경)
		- PlaceDelegate 처리 로직 변경
		- NEARBY로 인식할 경우에도 didEnterPlace, didLeavePlace 이벤트가 발생하는 버그 수정

#### 2018. 05. 09
- iOS SDK Version 1.0.8
		- 그래비티가 비활성화되어 있는 경우에도 광고가 수신되는 버그 수정
		- 그래비티 알림 클릭시 아무런 이벤트도 발생되지 않는 버그 수정
		- 그래비티에서 웹으로 이동시, SDK 자체 WebView로 띄우도록 변경
		- 그래비티에서 캠페인 테스트 모드일 경우 알림이 한번만 나오는 버그 수정
	
#### 2018. 04. 19
- iOS SDK Version 1.0.71
		- 특정상황에서 Plengi.init을 할 경우, unzeof 에서 오류나는 버그 수정

#### 2018. 04. 03
- iOS SDK Version 1.0.7
		- iOS 11.3 SDK로 업그레이드
		- Swift 4.0 > 4.1로 업그레이드
		- PlaceDelegate 에서 Leave / Enter Event 가 제대로 오지 않는 버그 수정

#### 2018. 03. 29
- iOS SDK Version 1.0.61
		- iOS SDK 누적 업데이트 포함
		- 장소 검색을 할 때 사용하는 내부 알고리즘 변경
		- 특정 상황에서 SDK가 강제중지되어 앱이 강제중지 되는 버그 수정

#### 2018. 03. 12
- iOS SDK Version v1 릴리즈

#### 2018. 02. 05
- iOS SDK Version v1 릴리즈 준비
	- Objective-C 에서 Swift로 framework 형식으로 변경 (정적파일 > framework로 변경됨)
	- 전체 API 변경
	- BLE 스캔 추가
	- developers.loplat.com 과 README.md 연동

#### 2017. 07. 20
- iOS sdk version 0.1.2 release
	- 업데이트 사항 : 위치 인식 성능 개선

#### 2017.06.05
- Sample App 수정
	- 업데이트 사항: Background fetch 설정 제외, Requeired background modes 수정
- Relam.framework 추가 방법 내용 수정 

#### 2017.01.20
- iOS sdk version 0.1.1 release
	- 업데이트 사항: bundle id check api 주소 변경
- **공지사항** : Sample app의 web view가 서버 주소 이전 작업으로 인하여 당분간 장소 인식 결과 화면이 보이지 않음

#### 2016.12.27
- iOS sdk version 0.1.0 release
- 업데이트 사항
	1. init시 현재 위치 장소 정보를 delegate에 return 함
	2. LTE상태에서는 서버 연결하지 않도록 설정

#### 2016.11.7
- framework -> static library 전환
- is_return_mainthread 추가

#### 2016.06.13 
- 배터리 퍼포먼스 개선

#### 2016.06.7
- initial release

