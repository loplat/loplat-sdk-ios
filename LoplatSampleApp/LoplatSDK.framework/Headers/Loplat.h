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
#import "Reachability.h"

@class LocationManager;


@protocol LoplatDelegate
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

+(Loplat *)getLoplat:(NSString *)client_id client_secret:(NSString *)client_secret;
-(void)startLocationUpdate:(int)interval;
-(void)restart;
//-(void)startAudioLoop;
//-(void)startFetchLoop;
-(void)stop;
-(NSDictionary *)getCurrentPlace;
@end