##### MiniPlengi SDK (for iOS)

<p class="danger">
	<b>loplat SDK 버전 1.0 미만은 곧 서비스가 중단될 예정이오니, 최신 SDK로 업데이트를 해주세요.</b>
</p>


## SDK 설치하기
### 프로젝트에 MiniPlengi SDK 적용하기
#### Cocoapod 적용하기

loplat SDK (Plengi SDK)를 사용하기 위해서는 Cocoapod 을 사용해야합니다. 

<p class="tip">
  <code>Cocoapods</code>는 Mac/iOS 개발 프로젝트의 라이브러리 관리 도구이며, 쉽게 생각해서 안드로이드의 <code>Gradle</code> 같은 존재입니다.<br>
  프로젝트에 이미 Cocoapods를 사용하고 있다면, <b>Cocoapod에 Plengi SDK 추가하기</b>로 넘어가세요.
</p>


#### Cocoapod 설치하기
Cocoapod 바이너리를 설치합니다. 터미널에 아래의 명령어를 입력하세요.
```bash
$ sudo gem install cocoapods
```



#### 프로젝트에 Cocoapod 사용하기
프로젝트에서 Cocoapod 모듈을 활성화합니다. 터미널에 아래의 명령어를 입력하세요.

```bash
$ cd $PROJECT_PATH
$ pod init
```

이제 해당 XCode 프로젝트에서 Cocoapod을 사용할 준비가 완료되었습니다.




#### Cocoapod에 Plengi SDK 추가하기
위의 명령어를 실행하면 프로젝트 폴더에 **Podfile** 이라는 파일이 생성됩니다.
Podfile을 텍스트 편집기로 열면 아래와 같은 형식의 내용이 나옵니다.

```Podfile
platform :ios, '8.0'
# use_frameworks!

target '<Your Target Name>' do
	pod 'AFNetworking', '~> 2.6'  // 예제
	pod 'ORStackView', '~> 3.0'   // 예제
	pod 'SwiftyJSON', '~> 2.3'    // 예제
end
```

Podfile의  target 태그안에 아래 내용을 추가 후 저장합니다.

```Podfile
pod 'MiniPlengi', '1.2.4'
```
<p class="tip">
SDK가 Swift를 사용하기 때문에, `# use_frameworks`에서 '#'을 제거하여 주석을 해제합니다.
</p>


모두 적용하면 아래가 같이 변경이 되어야합니다.

```Podfile
platform :ios, '8.0'
 use_frameworks!

target '<Your Target Name>' do
	pod 'AFNetworking', '~> 2.6'  // 예제
	pod 'ORStackView', '~> 3.0'   // 예제
	pod 'SwiftyJSON', '~> 2.3'    // 예제
	pod 'MiniPlengi', '1.2.4'
end
```



#### Cocoapod 라이브러리 설치하기
- 아래의 명령어를 터미널에서 실행하여 라이브러리를 적용합니다.
	
	```bash
	$ pod update
	$ pod install
	```



### Cocoapod이 적용된 프로젝트 열기

Cocoapod이 적용된 프로젝트를 열기 위해서는 **ProjectName.xcodeproj** 대신에, 워크스페이스 파일  **ProjectName.xcworkspace** 을 열여야 합니다.




## SDK 사용하기

### 1. 앱 권한 추가하기
#### 1) 권한 추가하기
- Plengi SDK를 사용하기 위해서는 권한을 추가해야합니다. 필요한 권한은 아래와 같습니다.
	```xcode_permissions
	Background Modes 
	- Location Updates
	- Uses Bluetooth LE accessories
	```
	
	XCode 에서 **프로젝트 > Capabilities**에 들어가 위 권한 목록에 있는 권한들을 허용해줍니다.
	
	![XCode에서 권한 허용하기](https://storage.googleapis.com/loplat-storage/public/sdk-doc/ios_3.png)
	
	##### 권한을 사용하는 이유
	
	- Background Modes - Location Updates
		- 백그라운드에서도 위치 정보를 수신하기 위해 사용합니다.

	- Background Modes - Uses Bluetooth LE accessories
		- 백그라운드에서도 BLE를 스캔하여 위치 인식에 정확도를 향상하기 위해 사용합니다.


#### 2) 위치 권한 사용 명시하기
iOS 11 이상부터 위치권한을 사용하기 위해서는 사용자에게 피드백 문구를 제공해야 합니다.

<p class="warning">
  사용목적에 따라 위치 권한 사용이유를 명시해주세요.
</p>

`info.plist` 파일에 아래 값을 추가합니다.

```xml
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

위의 코드를 Property List로 보면 아래와 같습니다.
![XCode info.plist](https://storage.googleapis.com/loplat-storage/public/sdk-doc/ios_2.png)



### 2. import 하기
#### 1) 헤더파일 포함하기
`AppDelegate.h` (Objective-C) / `AppDelegate.swift` (Swift) 파일에, 아래의 구문을 추가해줍니다.
Gravity를 사용할 경우 `UserNotifications` 기능을 소스코드에 포함시켜야합니다.

- Objective-C

	```objectivec
	@import MiniPlengi;
	@import UserNotifications; // Gravity를 사용할 경우
	```

- Swift

	```swift
	import MiniPlengi
	import UserNotifications // Gravity를 사용할 경우
	```



### 3.  Plengi SDK 초기화하기
`Plengi` 를 사용하기 위해서는 `init` 함수를 호출해야합니다.

<p class="danger">
  <code>Plengi.init()</code> 함수는 무조건 <code>AppDelegate</code> 에서만 호출되어야만 합니다.<br>
  그렇지 않을 경우, 예상치 못한 문제가 발생할 수 있으며, <code>Extension</code>, <code>ViewController</code> 클래스 등에서는 호출하면 안됩니다. 
</p>


####  1) Plengi SDK 초기화 - 일반적으로 앱이 시작되는 경우

- Objective-C

  `AppDelegate.h` 파일 클래스 선언부를 아래와 같이 수정합니다.

  ```objectivec
  @interface AppDelegate : UIResponder <UIApplicationDelegate, PlaceDelegate>
  ```

  `AppDelegate.m` 파일에 아래의 코드를 추가합니다.
  `echoCode` 는 <b>고객사 별 사용자를 트래킹 할 수 있는 고유 코드</b>를 인자값으로 넘겨줍니다. 따로 관리하지 않는다면 `NULL` 을 넘길 수 있습니다.

  <p class="danger">
    <code>echoCode</code>에는 <b>고객사 별 사용자를 트래킹 할 수 있는 고유 코드</b>를 넣으세요.<br>
    <b>절대로 개인정보는 넘기지 마세요.</b>
  </p>
  ```objectivec
  - (BOOL)application:(UIApplication *)application 
  		didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  	// ********** 중간 생략 ********** //
  	if ([Plengi initWithClientID:@"로플랫에서 발급받은 클라이언트 아이디" 
           			clientSecret:@"로플랫에서 발급받은 클라이언트 키" 
  						echoCode:@"고객사 별 사용자를 식별할 수 있는 코드 (개인정보 주의바람)"] == ResultSUCCESS) {
  		// init 성공
  	} else {
  		// init 실패
  	}
  	// ********** 중간 생략 ********** //
  }
  ```

- Swift
  `AppDelegate.swift` 파일 클래스 선언부를 아래와 같이 수정합니다.

  ```swift
  class AppDelegate: UIResponder, UIApplicationDelegate, PlaceDelegate {
  ```

  `AppDelegate.swift` 파일에 아래의 코드를 추가합니다.
  `echoCode` 는 <b>고객사 별 사용자를 트래킹 할 수 있는 고유 코드</b>를 인자값으로 넘겨줍니다. 따로 관리하지 않는다면 `nil` 을 넘길 수 있습니다.

  <p class="danger">
    <code>echoCode</code>에는 <b>고객사 별 사용자를 트래킹 할 수 있는 고유 코드</b>를 넣으세요.<br>
    <b>절대로 개인정보는 넘기지 마세요.</b>
  </p>

  ```swift
  func application(_ application: UIApplication, 
  	didFinishLaunchingWithOptions launchOptions: [IOApplicationLaunchOptionsKey: Any]?) -> Bool {
  	// ********** 중간 생략 ********** //
  	if Plengi.init(clientID: "로플랫에서 발급받은 클라이언트 아이디", clientSecret: "로플랫에서 발급받은 클라이언트 키", 
  		echoCode: "고객사 별 사용자를 식별할 수 있는 코드 (개인정보 주의바람)") 
  		== .SUCCESS) {
  		// init 성공
  	} else {
  		// init 실패
  	}
  	// ********** 중간 생략 ********** //
  }
  ```



####2) Plengi SDK 초기화 - 백그라운드에서 앱이 재시작되는 경우
<p class="warning">
  SDK가 재시작하기 위해 아래의 코드가 꼭 필요로 합니다.
  <br><br>
  <b>단, 이미 <code>application_didFinishLaunchingWithOptions</code> 에서 <code>Plengi.init</code> 를 호출하는 부분이 있다면 해당 단계는 넘겨도 됩니다.</b>
</p>

- Objective-C
  ```objectivec
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
  	(NSDictionary *)launchOptions {
  	if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
  		[Plengi initWithClientID:@"로플랫에서 발급받은 클라이언트 아이디" 
               		clientSecret:@"로플랫에서 발급받은 클라이언트 키" 
  						echoCode:@"고객사 별 사용자를 식별할 수 있는 코드 (개인정보 주의바람)"];
  	    [Plengi start];
  	}
  }
  ```

- Swift
  ```swift
  func application(_ application: UIApplication, didFinishLaunchingWithOptions 
  	launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  	if ((launchOptions?.index(forKey: UIApplicationLaunchOptionsKey.location)) != nil) { 
  	// 앱이 백그라운드 모드로 재시작 되었을 때 (필수!!!!! 없으면 재시작 되지 않음)
  		_ = Plengi.init(clientID: "로플랫에서 발급받은 클라이언트 아이디", 
  			clientSecret: "로플랫에서 발급받은 클라이언트 키", 
  			echoCode: "고객사 별 사용자를 식별할 수 있는 코드 (개인정보 주의바람)")
  		Plengi.start()   
      }
  }
  ```



####3) Bluetooth 권한 요청

Bluetooth 사용을 요청합니다. 알림은 없습니다.

- Objective-C
  ```objectivec
  - (void)applicationDidBecomeActive:(UIApplication *)application {
      [Plengi requestBluetooth];
  }
  ```

- Swift
  ```swift
  func applicationDidBecomeActive(_ application: UIApplication) {
  	_ = Plengi.requestBluetooth()
  }
  ```



### 4. PlaceDelegate 등록하기
Gravity 광고와 그 외 장소 인식 이벤트 발생시 이벤트를 수신하기 위해 `PlaceDelegate` 를 등록해줍니다.

- Objective-C

	Plengi 초기화 성공 후 `setDelegate` 를 호출합니다.

	```objectivec
	if ([Plengi setDelegate:self] == ResultSUCCESS) {
		// setDelegate 등록 성공
	} else {
		// setDelegate 등록 실패
	}
	```

	`AppDelegate.m` 파일에 아래의 코드를 추가합니다.
	
	```objectivec
	@implementation AppDelegate

	- (void)responsePlaceEvent:(PlengiResponse *)plengiResponse {
		if ([plengiResponse echoCode] != nil) {
			// 고객사에서 넣은 echoCode
		}
		
		if ([plengiResponse result] == ResultSUCCESS) {
			if ([plengiResponse type] == ResponseTypePLACE_EVENT) {
				if ([plengiResponse place] != nil) {
					if ([plengiResponse placeEvent] == PlaceEventENTER) {
						// 사용자가 장소에 들어왔을 때
					} else if ([plengiResponse placeEvent] == PlaceEventNEARBY) {
						// NEARBY로 인식되었을 때
					} else if ([plengiResponse placeEvent] == PlaceEventLEAVE) {
						// 사용자가 장소를 떠났을 때
					}
				}

				if ([plengiResponse complex] != nil) {
					// 복합몰이 인식되었을 때
				}

				if ([plengiResponse area] != nil) {
					// 상권이 인식되었을 때
				}

				if ([plengiResponse advertisement] != nil) {
					// Gravity 광고 정보가 있을 때
					// 기본으로 Plengi SDK에서 광고이벤트를 직접 알림으로 처리합니다.
					// 하지만 설정값에 따라 광고이벤트를 직접 처리할 경우 해당 객체를 사용합니다.
				}

				if ([plengiResponse geofence] != nil) {
					// Geofence 정보가 있을 때
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
	```


- Swift

	Plengi 초기화 성공 후 `setDelegate` 를 호출합니다.

	```swift
	if Plengi.setDelegate(self) == .SUCCESS {
		// setDelegate 등록 성공
	} else {
		// setDelegate 등록 실패
	}
	```

	`AppDelegate.swift` 파일에 아래의 코드를 추가합니다.
	
	```swift
	func responsePlaceEvent(_ plengiResponse: PlengiResponse) {
		if plengiResponse.echoCode != nil {
			// 고객사에서 설정한 echoCode
		}
		
		if plengiResponse.result == .SUCCESS {
			if plengiResponse.type == .PLACE_EVENT { // BACKGROUND
				if plengiResponse.place != nil {
					if plengiResponse.placeEvent == .ENTER {
						// PlaceEvent가 NEARBY 일 경우, NEARBY 로 인식된 장소 정보가 넘어옴
					} else if plengiResponse.placeEvent == .NEARBY {
						// PlaceEvent가 ENTER 일 경우, 들어온 장소 정보 객체가 넘어옴
					} else if plengiResponse.placeEvent == .LEAVE {
						// PlaceEvent가 LEAVE 일 경우, 떠난 장소 정보 객체가 넘어옴
					}
				}
	
				if plengiResponse.complex != nil {
					// 복합몰이 인식되었을 때
				}

				if plengiResponse.area != nil {
					// 상권이 인식되었을 때
				}
				
				if plengiResponse.advertisement != nil {
					// Gravity 광고 정보가 있을 때
					// 기본으로 Plengi SDK에서 광고이벤트를 직접 알림으로 처리합니다.
					// 하지만 설정값에 따라 광고이벤트를 직접 처리할 경우 해당 객체를 사용합니다.
				}

				if plengiResponse.geofence != nil {
					// Geofence 정보가 있을 때
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
	```
	

### 

### 5. Plengi SDK 시작

- Objective-C

	```objectivec
	[Plengi start];
	```

- Swift

	```swift
	Plengi.start()   
	```



### 6. 완료





## PlengiResponse
`PlaceDelegate` 에 전달되는 장소정보를 가지고 있는 객체입니다.

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

	<p class="tip">
	Place 객체에서 <code>accuracy > threshold</code> 여야만 Enter 이벤트입니다.<br>
	저 조건이 맞지 않는경우 <b>Near (옆에 있는 매장)</b> 입니다.
	</p>

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

- Advertisement

	```swift
	@objc public let body: String				// 광고 내용
	@objc public let campaign_id: Int			// Gravity 캠페인 고유번호
	@objc public let delay: Int					// 광고가 수신되기 전 딜레이
	@objc public let delay_type: String			// 광고 수신되기 전 딜레이 종류 (enter, leave)
	@objc public let img: String				// 광고에 포함된 이미지 URL
	@objc public let intent: String				// 광고를 클릭했을 때의 이벤트
	@objc public let msg_id: Int				// Gravity 광고 고유번호
	@objc public let target_pkg: String			// 광고에 해당하는 앱의 패키지명
	@objc public let title: String				// 광고 제목
	@objc public let client_code: String		// 광고에 대한 Client Code
	```

- Geofence & Fence : `GeoFence` (`PlengiResponse.Geofence` 클래스, `response.geofence` 결과 전달), fence 정보는 geofence 포함되어 전달

	```swift
	class GeoFence {
		@objc public let lat: Double				// Geofence 위도
		@objc public let lng: Double				// Geofence 경도
		@objc public let fences: Array<Fence>		// 하위 fence 리스트
	}

	class Fence {
		@objc public let gfid: Int					// fence ID
		@objc public let name: String				// fence 이름
		@objc public let dist: Double				// fence 중심 좌표와 사용자 위치 간 거리 
		@objc public let client_code: String		// fence의 대한 Client Code
	}
	```








## Gravity

로플랫 광고 플랫폼 Gravity를 사용하기 위하여, 추가 설정 및 Plengi SDK 함수를 호출해줘야 합니다.

### 1. Gravity 사용 설정하기
SDK에서 Gravity 를 사용하기 위해 함수를 호출해줍니다.

<p class="warning">
  <code>enableNoti</code>는 광고정보의 처리대상을 결정합니다. <br>
    <code>TRUE</code>일 경우, SDK에서 광고정보를 직접 iOS알림으로 유저에게 알립니다, (기본값) <br>
    <code>FALSE</code>일 경우, 광고 알림을 클라이언트앱에서 직접 관리할 수 있으며, SDK에서 처리하지 않습니다. 광고가 수신될 경우, <code>PlengiResponse</code> 객체 안에 <code>advertisement</code> 객체가 포함됩니다.
	<br><br>(자세한 내용은 상단의 `PlengiResponse` 설명을 참조하세요.)
</p>


#### 1)  Gravity 사용 설정 - 클라이언트 앱에서 직접 광고정보 처리

- Objective-C
	```objectivec
	[Plengi enableAdNetwork:YES enableNoti:NO];
	```

- Swift
	```swift
	Plengi.enableAdNetwork(true, enableNoti: false)
	```

#### 2) Gravity 사용 설정 - Plengi SDK에서 광고정보 처리

- Objective-C

  ```objectivec
  [Plengi enableAdNetwork:YES enableNoti:YES];
  ```

- Swift

  ```swift
  Plengi.enableAdNetwork(true, enableNoti: true)
  ```

#### 3) Gravity 비활성화하기

사용자가 푸시알림 동의를 하지 않을 경우 등 **광고 수신을 허용하지 않을 경우**,
아래의 코드를 추가하여 Gravity 사용을 중지합니다.

- Objective-C
  ```objectivec
  [Plengi enableAdNetwork:NO enableNoti:NO];
  ```

- Swift
  ```swift
  Plengi.enableAdNetwork(false, enableNoti: false)
  ```

  <p class="danger">
    <code>enableAdNetwork()</code>는 <code>start()</code>사용 전에 사용하셔야합니다.<br>
  </p>






### 2. 알림 권한 획득하기
Plengi SDK에서 직접 광고정보 처리 시 Gravity는 알림 기능을 사용해야 합니다.  따라서 알림 권한이 있어야만 정상 작동합니다.
`AppDelegate.m` / `AppDelegate.swift` 파일 초기화 작업에 아래 코드를 추가합니다.

- Objective-C
  ```objectivec
  UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert |
                                             UNAuthorizationOptionBadge |
                                             UNAuthorizationOptionSound) 
      completionHandler:^(BOOL granted, NSError * _Nullable error) {
      
    }
     
  if (@available(iOS 10.0, *)) {
  	UNUserNotificationCenter.currentNotificationCenter.delegate = self;
  }
  ```

- Swift
  ```swift
  if #available(iOS 10, *) {
  	UNUserNotificationCenter.current()
  		.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
  	UIApplication.shared.registerForRemoteNotifications()
  } else {
  	UIApplication.shared.registerUserNotificationSettings(
  		UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
      UIApplication.shared.registerForRemoteNotifications()
  }
  
  if #available(iOS  10.0, *) {
  	UNUserNotificationCenter.current().delegate = self
  }
  ```





### 3. Gravity 광고알림 처리하기
Plengi SDK에서 푸시알림을 직접 처리하기 위해 아래 코드를  추가합니다.

`AppDelegate.m` / `AppDelegate.swift` 파일에 `application_handleActionWithIdentifier` 이벤트를 추가하고, 아래의 코드를 추가하세요.

- Objective-C
  ```objectivec
  - (void)application:(UIApplication *)application
  	handleActionWithIdentifier:(NSString *)identifier 
  	  forLocalNotification:(UILocalNotification *)notification 
  	     completionHandler:(void (^)())completionHandler {
  	[Plengi processLoplatAdvertisement:application 
         		handleActionWithIdentifier:identifier 
  							  	   for:notification
      				 completionHandler:completionHandler];
  }
  
  - (void)userNotificationCenter:(UNUserNotificationCenter *)center 
  	   willPresentNotification:(UNNotification *)notification 
  	     withCompletionHandler:(void  (^)(UNNotificationPresentationOptions)) 
  	   completionHandler API_AVAILABLE(ios(10.0)) {  
             
  	// iOS 10 이상에서 포그라운드에 푸시알림을 표시합니다.
  	completionHandler(UNNotificationPresentationOptionAlert | 
  					  UNNotificationPresentationOptionBadge | 
  					  UNNotificationPresentationOptionSound);  
  }  
  
  - (void)userNotificationCenter:(UNUserNotificationCenter *)center 
  didReceiveNotificationResponse:(UNNotificationResponse *)response 
  		 withCompletionHandler:(void  (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {  
      // Plengi SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리합니다.
  	[Plengi processLoplatAdvertisement:center 
  							didReceive:response 			
       		     withCompletionHandler:completionHandler]; 
  	completionHandler();    
  }
  ```

- Swift
  ```swift
  func application(_ application: UIApplication, 
  	handleActionWithIdentifier identifier: String?, 
  	for notification: UILocalNotification, 
  	completionHandler: @escaping () -> Void) {
  	
  	Plengi.processLoplatAdvertisement(application, handleActionWithIdentifier: identifier, 
  		for: notification, completionHandler: completionHandler)
  }
  
  @available(iOS 10.0,  *) 
  func userNotificationCenter(_ center: UNUserNotificationCenter, 
  	didReceive response: UNNotificationResponse, 
  	withCompletionHandler completionHandler: @escaping ()  ->  Void) { 
      // Plengi SDK가 사용자의 알림 트래킹 (Click, Dismiss) 를 처리합니다.
  	Plengi.processLoplatAdvertisement(center,
  		 didReceive: response, 
  		 withCompletionHandler: completionHandler) 
  	completionHandler()  
  } 
  
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, 
  	willPresent notification: UNNotification, 
  	withCompletionHandler completionHandler: @escaping  (UNNotificationPresentationOptions) -> Void) { 
  	
  	// iOS 10 이상에서 포그라운드에 푸시알림을 표시합니다.
  	completionHandler([.alert,  .sound,  .badge])  		
  }
  ```



## 샘플앱
로플랫 SDK 샘플 앱은 Objective-C용과, Swift 용 둘 다 있습니다. 
(샘플앱 다운로드 > https://github.com/loplat/loplat-sdk-ios)

(샘플앱도 Cocoapod을 사용합니다. Cocoapod 사용법은 위에 명시되어 있습니다.)d
