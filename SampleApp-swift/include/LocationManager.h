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

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property (nonatomic) NSMutableDictionary *myLocationDictInPlist;
@property (nonatomic) NSMutableArray *myLocationArrayInPlist;

@property (nonatomic) BOOL afterResume;
@property Loplat *loplat;

+ (id)sharedManager;

- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;

- (void)addResumeLocationToPList;
- (void)addLocationToPList:(BOOL)fromResume;
- (void)addApplicationStatusToPList:(NSString*)applicationStatus;
- (void)stopMonitoring;

@end
