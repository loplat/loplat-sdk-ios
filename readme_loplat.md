### Loplat iOS SDK Settings

AGENDA
1. Background Mode 설정 
2. info.plist에 http: 서버 설정
3. info.plist 사용자 동의 안내문 설정 
4. Loplat iOS SDK Framework 추가, Realm Frmework 추가 
5. Header 경로 설정
6. Callback delegate 구현 (사용자용) 및 서버 결과값 예시
7. Start Parameter 설명
8. Swift 프로젝트에서 iOS SDK 호출법
9. Test Mode/ Production Mdoe 사용법


#### 1. Background Mode 설정 (Project Setting → Capability)
Location Update V 체크

<img src="http://i.imgur.com/MFeYHIT.png">


#### 2. info.plist http 서버 설정
#### 3. info.plist 사용자 동의 안내 설정
~~~xml
    <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
            <true/>
        </dict>
    <key>NSLocationAlwaysUsageDescription</key>
        <string>사용자 동의 안내 문장을 넣어주세요</string>
~~~

#### 4. 다운 받은 LoplatSDK.framework 추가 (Project Setting → General → Embedded Binaries에도 그림과 같이 추가)
(Realm Framework도 같은 방식으로 추가해야 합니다.)
<img src = "http://i.imgur.com/MOWhxfq.png">


#### 5. Header 경로 설정 
BuildSetting 의 Header Search Path에 $(PROJECT_DIR)/LoplatSDK.framework/include/AppleLocationLib를 추가한다.

<img src = "http://i.imgur.com/7ZPStaT.png">

6. Loplat Service Start 구현

*   AppDelegate.h

~~~objectivec
     #import <UIKit/UIKit.h>
     #import <LoplatSDK/Loplat.h>

    @interface AppDelegate : UIResponder <UIApplicationDelegate,LoplatDelegate>

    @property (strong, nonatomic) UIWindow *window;
    @property (strong, nonatomic) Loplat *loplat;

    @end
	
~~~

*   AppDelegate.m
~~~objectivec

    @synthesize loplat;

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        loplat=[Loplat getLoplat:@"test" client_secret:@"test"]; // client_id,client_secret을 입력
        [loplat startLocationUpdate:60];// 업데이트 간격을 초단위로 설정가능
        [loplat getCurrentPlace]; // 현재 위치 정보 return
        loplat.delegate=self;

        return YES;
    }

	-(void)DidEnterPlace:(NSDictionary *)currentPlace {
			// callback을 구현해 주세요.     
	}

	-(void)DidLeavePlace:(NSDictionary *)previousPlace {
			// callback을 구현해 주세요. 
    
	}
	// currentPlace와 previousPlace는 서버 return값의 위치를 찾은 경우의 json의 place tag와 같은 정보입니다. 
~~~

##### 서버 return 값

* 위치를 찾은 경우 
~~~json
{
	"status": "success",
	"place": {
		"category": "Cafe",
		"placename": "inalang cafe",
		"name": "inalang cafe",
		"tags": "인아랑",
		"lat_est": 37.468679941805902,
		"loplat_id": 12014,
		"floor": 1,
		"distance": 0,
		"place_type": "static",
		"lat": 37.468468000000001,
		"collector_id": "loplat",
		"threshold": 0.40000000000000002,
		"lng": 126.936708,
		"lng_est": 126.93979161384047,
		"client_code": null,
		"accuracy": 0.5
	},
	"type": "searchplace"
}
~~~

* 위치를 못 찾은 경우
~~~json
{ "status": "fail", "reason": "Location Acquisition Fail", "type": "searchplace" }
~~~

#### 7. Start parameter 설명

~~~objectivec
loplat=[Loplat getLoplat:@"test" client_secret:@"test"];
    [loplat startLocationUpdate:180 BatterySaveMode:2];// 업데이트 간격을 초단위로 설정가능
    loplat.delegate=self;
~~~

startLocationUpdate : Searching interval 
BatterySaveMode : (1~3)
1 : Heavy Battery Consumption
2 : Reasonable Battery Consumption
3 : Light Batter Consumption (possibly be bad accuracy)


#### 8. Swift 구현

<img src ="http://i.imgur.com/JCJcinH.png">

*   아무 Objective-C 파일을 생성하면 Bridge-Header 파일을 만들라는 알림창이 뜨는데 이때 동의 하면 bridge file들을 자동으로 만들어 준다.

-(ProjectName)-Bridging-Header.h

~~~objectivec
    #import <LoplatSDK/Loplat.h>`
~~~

*   AppDelegate.swift

~~~objectivec
     #import UIKit

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate,LoplatDelegate {

        var window: UIWindow?
        var loplat:Loplat!

        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            // Override point for customization after application launch.

            loplat = Loplat.getLoplat("test",client_secret: "test") // client_id,client_secret 설정
            loplat.startLocationUpdate(60) // update Interval 설정(초단위)
            loplat.delegate=self

            return true
        }

    func DidLoplatReport(result: [NSObject : AnyObject]!) {

    // Loplat Delegate 프로토콜 구현 (Delegate callback을 구현해 주세요)
          }  
~~~


** Background mode 설정중 Location Update는 Apple submission시에 Apple 기준에 적합하지 않은 Application이 사용한다고 판단할 시 reject 사유가 될 수 있습니다. Design Guide를 확인하시고, 진행해 주세요.  

#### 9. Test Mode/ Production Mode 사용법 
본 SDK를 사용하시려면, hello@cyranoproject.com 으로 Bundle ID와 회사이름을 알려주세요. Test Mode인 경우에는 등록과 동시에 Test Mode를 곧바로 사용하실 수 있습니다. Production Mode의 경우에도 마찬가지로 위의 이메일로 같은 정보를 알려주세요. Production Mode SDK를 release 받으셔서 사용하셔야 합니다. 

#### Trouble Shooting
만약 컴파일이 완료되었으나, run time exception 발생시에는 4번 내용과 같이 framework과 binary에 모두 framework을 추가하였는지 확인 해 주세요.