//
//  Place.h
//  LoplatSDK
//
//  Created by mac on 2016. 5. 24..
//  Copyright © 2016년 hansomecompany. All rights reserved.
//

#import <Realm/Realm.h>

@interface Place : RLMObject

@property NSString* name;
@property NSString* tags;
@property NSInteger floor;
@property float lat;
@property float lng;
@property float lat_est;
@property float lng_est;
@property float accuracy;
@property float threshold;
@property NSString *client_code;
@property NSString *category;
@property NSString *placename;
@property NSInteger loplat_id;
@property NSInteger distance;
@property NSString *collector_id;
@property NSDate *time;
@property NSString *place_type;

@end
