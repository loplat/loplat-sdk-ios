//
//  AppDelegate.h
//  LoplatSampleApp
//
//  Created by hieonn on 2016. 5. 25..
//  Copyright © 2016년 HANDSOME COMPANY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoplatSDK/Loplat.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoplatDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Loplat *loplat;

@end
