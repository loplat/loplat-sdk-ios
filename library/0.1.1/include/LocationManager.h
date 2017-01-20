//
//  LocationManager.h
//  Notibook
//
//  Created by mac on 2016. 5. 3..
//  Copyright © 2016년 snu_lib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Loplat.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@class Loplat;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationManager : NSObject

@property (nonatomic) CLLocationManager * anotherLocationManager;

@property Loplat *loplat;

+ (id)sharedManager;

- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)stopMonitoring;

@end
