//
//  Loplat.h
//  LocationFrameWork
//
//  Created by mac on 2016. 5. 8..
//  Copyright © 2016년 hansomecompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import "LocationTracker.h"
#import "Place.h"

#define TEST_MODE

@class LocationManager;


@protocol LoplatDelegate
@optional
-(void)WhereIsNow:(NSDictionary *)currentPlace;
@required
-(void)DidEnterPlace:(NSDictionary *)currentPlace;
-(void)DidLeavePlace:(NSDictionary *)previousPlace;
@end


@interface Loplat : NSObject{
    BOOL permission;
}

@property LocationTracker * locationTracker;
@property (nonatomic,strong) NSTimer* locationUpdateTimer;
@property (strong, nonatomic) LocationManager *shareModel;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) id timeObserver;
@property (weak,nonatomic) id<LoplatDelegate> delegate;

+(Loplat *)getLoplat:(NSString *)client_id client_secret:(NSString *)client_secret is_return_mainthread:(BOOL)is_return_mainthread;
-(void)startLocationUpdate:(int)interval;
-(void)restart;
-(void)stop;
-(NSDictionary *)getCurrentPlace;
-(void)resetTimer:(NSInteger)time;
-(void)queryToServer:(NSString *)bssid ssid:(NSString *)ssid;
-(void)PlaceToDelegate:(NSData *)data;
@end
