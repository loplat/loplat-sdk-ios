//
//  MainViewController.m
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "MainViewController.h"
@import Foundation;

@interface MainViewController ()

@end

@implementation MainViewController

- (void)setup {
    [super setup];
    
    self.title = @"MiniPlengi Sample (Objective-C)";
    [self requestLocationAlwaysPermission:NO];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"위치 권한 (항상 허용) 허용하기" key:@"location_permission" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                if (!self.isLocationPermissionAllowed) {
                    [self requestLocationAlwaysPermission:YES];
                } else {
                    [self openDialog:@"위치 권한 허용됨" forMessage:@"이미 위치권한이 허용되었습니다."];
                }
            };
        }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"알림 권한 허용하기" key:@"notification_permission" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                if (@available(iOS 10.0, *)) {
                    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                              if (error != nil) {
                                                  [self openDialog:@"알림 권한 허용 실패" forMessage:@"알림 권한한을 부여받는데에 실패하였습니다."];
                                              } else {
                                                  [self openDialog:@"알림 권한 허용됨" forMessage:@"알림 권한이 허용되었습니다."];
                                              }
                                          }];
                } else {
                    // Fallback on earlier versions
                }
            };
        }]];
        
        section.footerTitle = @"로플랫 SDK를 사용하기 위해서는 위치 권한(항상 허용)은 필수로 필요하며, 알림 권한은 Gravity를 사용할 경우에 필요로 합니다. 권한 허용 API는 MiniPlengi에서는 제공하고 있지 않기에, 직접 구현하거나, developers.loplat.com을 참조해주세요.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOTextTableViewCell cellWithTitle:@"클라이언트 아이디" key:@"client_id" handler:^(BOTextTableViewCell* cell) {
            cell.textField.placeholder = @"client_id";
        }]];
        
        [section addCell:[BOTextTableViewCell cellWithTitle:@"클라이언트 키" key:@"client_secret" handler:^(BOTextTableViewCell* cell) {
            cell.textField.placeholder = @"client_secret";
        }]];
        
        [section addCell:[BOTextTableViewCell cellWithTitle:@"에코 코드" key:@"echo_code" handler:^(BOTextTableViewCell* cell) {
            cell.textField.placeholder = @"echo_code";
        }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 초기화" key:@"init" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                BOOL isClientFieldEmpty = YES;
                
                NSString* client_id = [NSUserDefaults.standardUserDefaults stringForKey:@"client_id"];
                NSString* client_secret = [NSUserDefaults.standardUserDefaults stringForKey:@"client_secret"];
                NSString* echo_code = [NSUserDefaults.standardUserDefaults stringForKey:@"echo_code"];
                
                if (![client_id isEqualToString:@""] && ![client_secret isEqualToString:@""]) {
                    isClientFieldEmpty = NO;
                    
                    if ([Plengi initWithClientID:client_id
                                    clientSecret:client_secret
                                        echoCode:echo_code] == ResultSUCCESS) {
                        AppDelegate* appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
                        [appDelegate registerPlaceEngineDelegate];
                    } else {
                        [self openDialog:@"이미 초기화 됨" forMessage:@"이미 SDK가 초기화 되었습니다."];
                    }
                }
                
                if (isClientFieldEmpty) {
                    [self openDialog:@"Client ID/Secret 입력 안됨" forMessage:@"필수 항목이 누락되었습니다."];
                }
            };
        }]];
        
        section.footerTitle = @"로플랫으로부터 발급받은 client_id / client_secret을 입력한 후, SDK 초기화 버튼을 누르세요. \n\n주기의 단위는 '초' 이며, 최소 시간은 60초입니다. 60초 미만일 경우, 최저 주기인 60초로 자동 설정됩니다.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 시작" key:@"start" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                AppDelegate* appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
                [appDelegate startSDK];
            };
        }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 정지" key:@"stop" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                AppDelegate* appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
                [appDelegate stopSDK];
            };
        }]];
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"장소 요청 (refreshPlace)" key:@"refreshPlace" handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                AppDelegate* appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
                [appDelegate refreshPlace];
            };
        }]];
        
        section.footerTitle = @"해당 기능은 테스트 용도로만 사용되어야만 하며, 릴리즈 앱에서는 사용하지 마세요.\n\n릴리즈 앱에서는 start() 메소드를 통해 타이머에 의해 동작이 되어야만 합니다.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"Gravity 사용" key:@"enable_gravity" handler:^(BOSwitchTableViewCell* cell) {
            
        }]];
        
        section.footerTitle = @"로플랫 광고 (Gravity)를 사용할 수 있습니다. 기본값은 SDK가 광고에 대한 알림을 처리하지만, 옵션에 따라 광고에 대한 이벤트를 직접 처리할 수 있습니다.";
    }]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isOpened) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* informationViewController = [storyboard instantiateViewControllerWithIdentifier:@"informationViewController"];
        
        [self presentViewController:informationViewController animated:YES completion:nil];
        
        self.isOpened = YES;
    }
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)requestLocationAlwaysPermission:(BOOL)isManual {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            if (isManual) {
                self.locationManager = [CLLocationManager new];
                [self.locationManager requestAlwaysAuthorization];
            }
            
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            self.isLocationPermissionAllowed = NO;
            
            [self openDialog:nil forMessage:@"위치 권한을 허용할 수 없습니다. 환경설정에서 직접 위치권한을 허용해주세요."];
            
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            self.isLocationPermissionAllowed = YES;
            break;
    }
}

- (void)openDialog:(NSString*)title forMessage:(NSString*)message {
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle: title
                                                    message: message
                                                      image: nil
                                            buttonAlignment: UILayoutConstraintAxisVertical
                                            transitionStyle: PopupDialogTransitionStyleBounceUp
                                             preferredWidth: 380
                                        tapGestureDismissal: NO
                                        panGestureDismissal: NO
                                              hideStatusBar: NO
                                                 completion: nil];
    DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"확인"
                                                    height: 45
                                              dismissOnTap: YES
                                                    action: nil];
    [popup addButton:ok];
    [self presentViewController:popup animated:YES completion:nil];
}
@end
