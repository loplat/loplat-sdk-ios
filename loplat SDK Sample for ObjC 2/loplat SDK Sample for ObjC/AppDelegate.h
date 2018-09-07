//
//  AppDelegate.h
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

@import UIKit;
@import UserNotifications;
@import PopupDialog;
@import MiniPlengi;

#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PlaceDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerPlaceEngineDelegate;
- (void)startSDK;
- (void)stopSDK;
- (void)refreshPlace;
- (void)setGravity:(BOOL)isEnabled;

@end
