//
//  MainViewController.h
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "AppDelegate.h"
#import <Bohr/Bohr.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : BOTableViewController

@property (nonatomic, assign) BOOL isOpened;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, assign) BOOL isLocationPermissionAllowed;
@property (nonatomic, assign) BOOL isNotificationPermissionAllowed;

@end

