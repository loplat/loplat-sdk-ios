### Loplat iOS SDK Settings

AGENDA
1. Background Mode ���� 
2. info.plist�� http: ���� ����
3. info.plist ����� ���� �ȳ��� ���� 
4. Loplat iOS SDK Framework �߰�, Realm Frmework �߰� 
5. Header ��� ����
6. Callback delegate ���� (����ڿ�) �� ���� ����� ����
7. Start Parameter ����
8. Swift ������Ʈ���� iOS SDK ȣ���
9. Test Mode/ Production Mdoe ����


#### 1. Background Mode ���� (Project Setting �� Capability)
Location Update V üũ

<img src="http://i.imgur.com/MFeYHIT.png">


#### 2. info.plist http ���� ����
#### 3. info.plist ����� ���� �ȳ� ����
~~~xml
    <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
            <true/>
        </dict>
    <key>NSLocationAlwaysUsageDescription</key>
        <string>����� ���� �ȳ� ������ �־��ּ���</string>
~~~

#### 4. �ٿ� ���� LoplatSDK.framework �߰� (Project Setting �� General �� Embedded Binaries���� �׸��� ���� �߰�)
(Realm Framework�� ���� ������� �߰��ؾ� �մϴ�.)
<img src = "http://i.imgur.com/MOWhxfq.png">


#### 5. Header ��� ���� 
BuildSetting �� Header Search Path�� $(PROJECT_DIR)/LoplatSDK.framework/include/AppleLocationLib�� �߰��Ѵ�.

<img src = "http://i.imgur.com/7ZPStaT.png">

6. Loplat Service Start ����

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

        loplat=[Loplat getLoplat:@"test" client_secret:@"test"]; // client_id,client_secret�� �Է�
        [loplat startLocationUpdate:60];// ������Ʈ ������ �ʴ����� ��������
        [loplat getCurrentPlace]; // ���� ��ġ ���� return
        loplat.delegate=self;

        return YES;
    }

	-(void)DidEnterPlace:(NSDictionary *)currentPlace {
			// callback�� ������ �ּ���.     
	}

	-(void)DidLeavePlace:(NSDictionary *)previousPlace {
			// callback�� ������ �ּ���. 
    
	}
	// currentPlace�� previousPlace�� ���� return���� ��ġ�� ã�� ����� json�� place tag�� ���� �����Դϴ�. 
~~~

##### ���� return ��

* ��ġ�� ã�� ��� 
~~~json
{
	"status": "success",
	"place": {
		"category": "Cafe",
		"placename": "inalang cafe",
		"name": "inalang cafe",
		"tags": "�ξƶ�",
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

* ��ġ�� �� ã�� ���
~~~json
{ "status": "fail", "reason": "Location Acquisition Fail", "type": "searchplace" }
~~~

#### 7. Start parameter ����

~~~objectivec
loplat=[Loplat getLoplat:@"test" client_secret:@"test"];
    [loplat startLocationUpdate:180 BatterySaveMode:2];// ������Ʈ ������ �ʴ����� ��������
    loplat.delegate=self;
~~~

startLocationUpdate : Searching interval 
BatterySaveMode : (1~3)
1 : Heavy Battery Consumption
2 : Reasonable Battery Consumption
3 : Light Batter Consumption (possibly be bad accuracy)


#### 8. Swift ����

<img src ="http://i.imgur.com/JCJcinH.png">

*   �ƹ� Objective-C ������ �����ϸ� Bridge-Header ������ ������ �˸�â�� �ߴµ� �̶� ���� �ϸ� bridge file���� �ڵ����� ����� �ش�.

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

            loplat = Loplat.getLoplat("test",client_secret: "test") // client_id,client_secret ����
            loplat.startLocationUpdate(60) // update Interval ����(�ʴ���)
            loplat.delegate=self

            return true
        }

    func DidLoplatReport(result: [NSObject : AnyObject]!) {

    // Loplat Delegate �������� ���� (Delegate callback�� ������ �ּ���)
          }  
~~~


** Background mode ������ Location Update�� Apple submission�ÿ� Apple ���ؿ� �������� ���� Application�� ����Ѵٰ� �Ǵ��� �� reject ������ �� �� �ֽ��ϴ�. Design Guide�� Ȯ���Ͻð�, ������ �ּ���.  

#### 9. Test Mode/ Production Mode ���� 
�� SDK�� ����Ͻ÷���, hello@cyranoproject.com ���� Bundle ID�� ȸ���̸��� �˷��ּ���. Test Mode�� ��쿡�� ��ϰ� ���ÿ� Test Mode�� ��ٷ� ����Ͻ� �� �ֽ��ϴ�. Production Mode�� ��쿡�� ���������� ���� �̸��Ϸ� ���� ������ �˷��ּ���. Production Mode SDK�� release �����ż� ����ϼž� �մϴ�. 

#### Trouble Shooting
���� �������� �Ϸ�Ǿ�����, run time exception �߻��ÿ��� 4�� ����� ���� framework�� binary�� ��� framework�� �߰��Ͽ����� Ȯ�� �� �ּ���.