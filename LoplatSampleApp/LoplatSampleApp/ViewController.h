//
//  ViewController.h
//  LoplatSampleApp
//
//  Created by hieonn on 2016. 5. 25..
//  Copyright © 2016년 HANDSOME COMPANY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <LoplatSDK/Loplat.h>

@interface ViewController : UIViewController<RefreshDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet UIButton *startbtn;
@property (weak, nonatomic) IBOutlet UIButton *stopbtn;
@property (weak, nonatomic) IBOutlet UIButton *currentPlacebtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshbtn;
@property BOOL running;
-(IBAction)start:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)currentPlace:(id)sender;
-(IBAction)refresh:(id)sender;


@end

