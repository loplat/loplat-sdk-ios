//
//  AppDelegate.m
//  LoplatSampleApp
//
//  Created by hieonn on 2016. 5. 25..
//  Copyright © 2016년 HANDSOME COMPANY. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize loplat;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    loplat=[Loplat getLoplat:@"test" client_secret:@"test"];
    [loplat startLocationUpdate:180];// 업데이트 간격을 초단위로 설정가능
    loplat.delegate=self;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


- (void)DidEnterPlace:(NSDictionary *)currentPlace {
    
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    NSString *bssid;
    NSString *ssid;
    for (NSString *ifnam in ifs) {
        info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        bssid=info[@"BSSID"];
        ssid=info[@"SSID"];
    }
    
    
    
    if(!bssid){
        bssid=@"00:00:00:00:00:00";
    }else{
        bssid=[self bssidTo12Digit:bssid];
    }

    
    NSString *name=[currentPlace objectForKey:@"name"];
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i-handsome.com/tc/loplat/bssid_report.php?bssid=%@&category=1&bundle=%@&placename=%@",bssid,bundleIdentifier,[name stringByAddingPercentEncodingWithAllowedCharacters:set]]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
}

- (void)DidLeavePlace:(NSDictionary *)previousPlace {
    
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    NSString *bssid;
    NSString *ssid;
    for (NSString *ifnam in ifs) {
        info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        bssid=info[@"BSSID"];
        ssid=info[@"SSID"];
    }
    
    
    
    if(!bssid){
        bssid=@"00:00:00:00:00:00";
    }else{
        bssid=[self bssidTo12Digit:bssid];
    }

    
    NSString *name=[previousPlace objectForKey:@"name"];
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i-handsome.com/tc/loplat/bssid_report.php?bssid=%@&category=2&bundle=%@&placename=%@",bssid,bundleIdentifier,[name stringByAddingPercentEncodingWithAllowedCharacters:set]]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
}

-(NSString *)bssidTo12Digit:(NSString *)bssid{
    
    NSArray *strings = [bssid componentsSeparatedByString:@":"];
    NSMutableString *result=[[NSMutableString alloc]init];
    for(int i=0;i<[strings count];i++){
        
        NSString *token=[strings objectAtIndex:i];
        if([token length]==1){
            token=[@"0" stringByAppendingString:token];
        }
        if(i!=[strings count]-1){
            token=[token stringByAppendingString:@":"];
        }
        
        [result appendString:token];
        
    }
    
    return [NSString stringWithString:result];
}




@end
