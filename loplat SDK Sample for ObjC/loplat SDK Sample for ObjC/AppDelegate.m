//
//  AppDelegate.m
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        NSString *client_id = [NSUserDefaults.standardUserDefaults stringForKey:@"client_id"];
        NSString *client_password = [NSUserDefaults.standardUserDefaults stringForKey:@"client_secret"];
        NSInteger* integer = [NSUserDefaults.standardUserDefaults integerForKey:@"integer"];
        
        if (client_id != NULL && client_password != NULL) {
            [Plengi initWithClientID:client_id clientSecret:client_password echoCode];
            [Plengi start:integer];
        }
    }
    
    self.window = [UIWindow new];
    self.window.frame = [UIScreen.mainScreen bounds];
    self.window.rootViewController = [[UINavigationController new] initWithRootViewController:[MainViewController new]];
    [self.window makeKeyAndVisible];
    
    [self setupAppearence];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    }
    
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"enable_gravity" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"enable_gravity"]) {
        BOOL enable_gravity = [NSUserDefaults.standardUserDefaults boolForKey:@"enable_gravity"];
        [self setGravity:enable_gravity];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [NSNotificationCenter.defaultCenter postNotificationName:@"processAdvertisement" object:NULL];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    [Plengi processLoplatAdvertisement:application handleActionWithIdentifier:identifier for:notification completionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void  (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);  //
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void  (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    [Plengi processLoplatAdvertisement:center didReceive: response withCompletionHandler:completionHandler];
    completionHandler();
}

/// 로플랫 SDK에서 장소 인식 등 서버로부터 응답이 온 경우, 해당 Delegate가 호출됩니다.
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerPlaceEngineDelegate {
    if ([Plengi setDelegate:self] == Result.SUCCESS) {
        
    } else {
        PopupDialog *popup = [[PopupDialog alloc] initWithTitle: @"초기화에 실패하였습니다."
                                                        message: @"Plengi.setDelegate() 메소드에서 FAILED를 반환했습니다."
                                                          image: nil
                                                buttonAlignment: UILayoutConstraintAxisVertical
                                                transitionStyle: PopupDialogTransitionStyleBounceUp
                                                 preferredWidth: 380
                                            tapGestureDismissal: NO
                                            panGestureDismissal: NO
                                                  hideStatusBar: NO
                                                     completion: nil];
        DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"확인"
                                                          height: 45
                                                    dismissOnTap: YES
                                                          action: nil];
        [popup addButton:ok];
        [self.window.rootViewController presentViewController:popup animated:TRUE completion:NULL];
    }
}

- (void)startSDK:(int)interval {
    if ([Plengi start:interval] == Result.FAIL) {
        PopupDialog *popup = [[PopupDialog alloc] initWithTitle: @"SDK를 시작할 수 없음"
                                                        message: @"SDK가 이미 시작 상태입니다."
                                                          image: nil
                                                buttonAlignment: UILayoutConstraintAxisVertical
                                                transitionStyle: PopupDialogTransitionStyleBounceUp
                                                 preferredWidth: 380
                                            tapGestureDismissal: NO
                                            panGestureDismissal: NO
                                                  hideStatusBar: NO
                                                     completion: nil];
        DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"확인"
                                                          height: 45
                                                    dismissOnTap: YES
                                                          action: nil];
        [popup addButton:ok];
        [self.window.rootViewController presentViewController:popup animated:TRUE completion:NULL];
    }
}

- (void)stopSDK {
    if ([Plengi stop] == Result.FAIL) {
        PopupDialog *popup = [[PopupDialog alloc] initWithTitle: @"SDK를 정지할 수 없음"
                                                        message: @"SDK가 이미 정지 상태입니다."
                                                          image: nil
                                                buttonAlignment: UILayoutConstraintAxisVertical
                                                transitionStyle: PopupDialogTransitionStyleBounceUp
                                                 preferredWidth: 380
                                            tapGestureDismissal: NO
                                            panGestureDismissal: NO
                                                  hideStatusBar: NO
                                                     completion: nil];
        DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"확인"
                                                          height: 45
                                                    dismissOnTap: YES
                                                          action: nil];
        [popup addButton:ok];
        [self.window.rootViewController presentViewController:popup animated:TRUE completion:NULL];
    }
}

- (void)setGravity:(BOOL)isEnabled {
    [Plengi enableAdNetwork:isEnabled enableNoti:TRUE];
}

- (void)setupAppearence {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar.appearance.barTintColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
    UINavigationBar.appearance.tintColor = UIColor.whiteColor;
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    UITableView.appearance.backgroundColor = [[UIColor new] initWithWhite:0.95 alpha:1];
    
    BOTableViewSection.appearance.headerTitleColor = [[UIColor new] initWithWhite:0.5 alpha:1];
    BOTableViewSection.appearance.footerTitleColor = [[UIColor new] initWithWhite:0.6 alpha:1];
    
    BOTableViewCell.appearance.mainColor = [[UIColor new] initWithWhite:0.3 alpha:1];
    BOTableViewCell.appearance.secondaryColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
    BOTableViewCell.appearance.selectedColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
}


@end
