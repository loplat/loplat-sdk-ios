//
//  AppDelegate.m
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "AppDelegate.h"
@import MiniPlengi;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 앱이 백그라운드 모드로 재시작 되었을 때 MiniPlengi를 재시작합니다.
    // 초기화를 didFinishLaunchingWithOptions 에서 항상 하지 않는다면
    // 꼭 아래와 같은 작업을 하셔야합니다.
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"echo_code"]) {
            [Plengi start];
            [Plengi setIsDebug:YES];
        }
    }
    
    self.window = [UIWindow new];
    self.window.frame = [UIScreen.mainScreen bounds];
    self.window.rootViewController = [[UINavigationController new] initWithRootViewController:[MainViewController new]];
    [self.window makeKeyAndVisible];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    }
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [NSNotificationCenter.defaultCenter postNotificationName:@"processAdvertisement" object:nil];
}

-        (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
      forLocalNotification:(UILocalNotification *)notification
         completionHandler:(void (^)())completionHandler {
    if ([Plengi processLoplatAdvertisement:application
                handleActionWithIdentifier:identifier
                                       for:notification
                         completionHandler:completionHandler] != ResultSUCCESS) {
        // fail
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void  (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    completionHandler(UNNotificationPresentationOptionAlert |
                      UNNotificationPresentationOptionBadge |
                      UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void  (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    if ([Plengi processLoplatAdvertisement:center
                                didReceive:response
                     withCompletionHandler:completionHandler] != ResultSUCCESS) {
        // fail
    }
    completionHandler();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [Plengi requestBluetooth]; // Bluetooth 사용을 요청합니다. 알림은 없습니다.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)initPlengi:(NSString *)echoCode {
    return [Plengi initWithClientID:@"loplatdemo"
                       clientSecret:@"loplatdemokey"
                           echoCode:echoCode] == ResultSUCCESS;
}

@end
