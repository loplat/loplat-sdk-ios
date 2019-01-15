//
//  MainViewController.m
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@import CoreLocation;
@import UserNotifications;

@import PopupDialog;
@import MiniPlengi;

@interface MainViewController () <PlaceDelegate>
{
    BOOL _isOpened;
}

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (weak,   nonatomic) BOTableViewSection* engineStatusSection;

@end

@implementation MainViewController

- (NSString*)engineStatusMessage {
    return [NSString stringWithFormat:@"MiniPlengi is %@", [Plengi getEngineStatus] == EngineStatusSTARTED ? @"started" : @"stopped"];
}

- (BOOL)locationAgreement {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"locationAgreement"];
}

- (BOOL)marketingAgreement {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"marketingAgreement"];
}

- (BOOL)enableGravity {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"enable_gravity"];
}

- (void)setEnableGravity:(BOOL)enable {
    [NSUserDefaults.standardUserDefaults setBool:enable forKey:@"enable_gravity"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _engineStatusSection = nil;
    _isOpened = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isOpened) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* informationViewController = [storyboard instantiateViewControllerWithIdentifier:@"informationViewController"];
        
        [self presentViewController:informationViewController animated:YES completion:nil];
        
        _isOpened = YES;
    }
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupAppearence {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar.appearance.barTintColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
    UINavigationBar.appearance.tintColor = UIColor.whiteColor;
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    UITableView.appearance.backgroundColor = [[UIColor new] initWithWhite:0.95 alpha:1];
    
    BOTableViewSection.appearance.headerTitleColor = [[UIColor new] initWithWhite:0.5 alpha:1];
    BOTableViewSection.appearance.footerTitleColor = [[UIColor new] initWithWhite:0.6 alpha:1];
    
    BOTableViewCell.appearance.mainColor = [[UIColor new] initWithWhite:0.3 alpha:1];
    BOTableViewCell.appearance.secondaryColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
    BOTableViewCell.appearance.selectedColor = [[UIColor new] initWithRed:71 / 255.0 green:165.0 / 255.0 blue:254.0 / 255.0 alpha:1.0];
}

- (void)setup {
    [super setup];
    
    self.title = @"MiniPlengi Sample (Objective-C)";
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@""
                                                        handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"위치 권한 (항상 허용) 허용하기"
                                                          key:@"location_permission"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                switch (CLLocationManager.authorizationStatus) {
                    case kCLAuthorizationStatusNotDetermined: {
                        [self.locationManager requestAlwaysAuthorization];
                    }
                        break;
                        
                    case kCLAuthorizationStatusRestricted:
                    case kCLAuthorizationStatusDenied:
                    case kCLAuthorizationStatusAuthorizedWhenInUse:
                        [self customAlertWithTitle:@"위치 권한"
                                           message:@"위치 권한이 없습니다. \n설정에서 항상으로 변경해주세요."
                                            action:@"이동"
                                            cancel:@"취소"
                                           handler:^{
                                               NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                               if (@available(iOS 10.0, *))
                                               {
                                                   [UIApplication.sharedApplication openURL:url
                                                                                    options:@{}
                                                                          completionHandler:nil];
                                               }
                                               else
                                               {
                                                   [UIApplication.sharedApplication openURL:url];
                                               }
                                           }];
                        break;
                    case kCLAuthorizationStatusAuthorizedAlways:
                        [self customAlertWithTitle:@"위치 권한 허용됨"
                                           message:@"이미 위치권한이 허용되었습니다."];
                        break;
                }
            };
        }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"알림 권한 허용하기"
                                                          key:@"notification_permission"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                if (@available(iOS 10.0, *)) {
                    [UNUserNotificationCenter.currentNotificationCenter
                     getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        switch (settings.authorizationStatus) {
                            case UNAuthorizationStatusNotDetermined:
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UNUserNotificationCenter.currentNotificationCenter
                                     requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
                                                                     UNAuthorizationOptionBadge |
                                                                     UNAuthorizationOptionSound
                                     completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                     }];
                                    [UIApplication.sharedApplication registerForRemoteNotifications];
                                });
                                break;
                                
                            case UNAuthorizationStatusDenied:
                                [self customAlertWithTitle:@"알림 권한"
                                                   message:@"알림 권한이 없습니다. \n설정에서 사용으로 변경해주세요."
                                                    action:@"이동"
                                                    cancel:@"취소"
                                                   handler:^{
                                                       NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                       if (@available(iOS 10.0, *))
                                                       {
                                                           [UIApplication.sharedApplication openURL:url
                                                                                            options:@{}
                                                                                  completionHandler:nil];
                                                       }
                                                       else
                                                       {
                                                           [UIApplication.sharedApplication openURL:url];
                                                       }
                                                   }];
                                break;
                                
                            case UNAuthorizationStatusAuthorized:
                                [self customAlertWithTitle:@"알림 권한 허용됨"
                                                   message:@"이미 알림권한이 허용되었습니다."];
                                break;
                            case UNAuthorizationStatusProvisional:
                                [self customAlertWithTitle:@"알림 권한 허용됨"
                                                   message:@"알림이 조용히 전달 상태입니다."];
                                break;
                        }
                    }];
                }
                else {
                    if (!UIApplication.sharedApplication.isRegisteredForRemoteNotifications) {
                        UIUserNotificationSettings* setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                                                                           UIUserNotificationTypeBadge |
                                                                                                           UIUserNotificationTypeSound
                                                                                                categories:nil];
                        [UIApplication.sharedApplication registerUserNotificationSettings:setting];
                        [UIApplication.sharedApplication registerForRemoteNotifications];
                    }
                    else {
                        [self customAlertWithTitle:@"알림 권한 허용됨"
                                           message:@"이미 알림권한이 허용되었습니다."];
                    }
                }
            };
        }]];
        
        section.footerTitle = @"로플랫 SDK를 사용하기 위해서는 위치 권한(항상 허용)은 필수로 필요하며, 알림 권한은 Gravity를 사용할 경우에 필요로 합니다. 권한 허용 API는 MiniPlengi에서는 제공하고 있지 않기에, 직접 구현하거나, developers.loplat.com을 참조해주세요.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"" handler:^(BOTableViewSection *section) {
        [section addCell:[BOTextTableViewCell cellWithTitle:@"에코 코드"
                                                        key:@"echo_code"
                                                    handler:^(BOTextTableViewCell* cell) {
                                                        cell.textField.placeholder = @"echo_code";
                                                    }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 초기화"
                                                          key:@"init"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                NSString* echo_code = [NSUserDefaults.standardUserDefaults stringForKey:@"echo_code"];
                if (!echo_code) {
                    [self customAlertWithTitle:@"필수 항목이 누락되었습니다."
                                       message:@"에코 코드를 입력해주세요."];
                    return;
                }
                
                AppDelegate* appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
                if ([appDelegate initPlengi:echo_code]) {
                    [self registerPlaceEngineDelegate];
                    [Plengi setIsDebug:YES];
                }
            };
        }]];
        
        section.footerTitle = @"echo code를 입력한 후, SDK 초기화 버튼을 누르세요";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@""
                                                        handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 시작"
                                                          key:@"start"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                [self startSDK];
            };
        }]];
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"SDK 정지"
                                                          key:@"stop"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                [self stopSDK:YES];
            };
        }]];
                                                            
        section.footerTitle = [self engineStatusMessage];
        self.engineStatusSection = section;
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@""
                                                        handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"장소 요청 (refreshPlace)"
                                                          key:@"refreshPlace"
                                                      handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                [self refreshPlace];
            };
        }]];
        
        section.footerTitle = @"해당 기능은 테스트 용도로만 사용되어야만 하며, 릴리즈 앱에서는 사용하지 마세요.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@""
                                                        handler:^(BOTableViewSection *section) {
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"Gravity 사용"
                                                          key:@"enable_gravity"
                                                      handler:^(BOSwitchTableViewCell* cell) {
            [cell.toggleSwitch addTarget:self
                                  action:@selector(enableGravity:)
                        forControlEvents:UIControlEventValueChanged];
        }]];
        
        section.footerTitle = @"로플랫 광고 (Gravity)를 사용할 수 있습니다.";
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@""
                                                        handler:^(BOTableViewSection *section) {
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"사용자 마케팅 동의"
                                                          key:@"marketingAgreement"
                                                      handler:^(BOSwitchTableViewCell* cell) {
        [cell.toggleSwitch addTarget:self
                              action:@selector(marketingAgreement:)
                    forControlEvents:UIControlEventValueChanged];
        }]];
                                                            
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"사용자 위치정보 동의"
                                                          key:@"locationAgreement"
                                                      handler:^(BOSwitchTableViewCell* cell) {
        [cell.toggleSwitch addTarget:self
                              action:@selector(locationAgreement:)
                    forControlEvents:UIControlEventValueChanged];
        }]];
        
        section.footerTitle = @"사용자 동의 여부에 따른 시나리오를 확인합니다.";
    }]];
}

/// 로플랫 SDK에 Delegate를 등록합니다.
/// `[Plengi setDelegate]` 메소드는 반환값이 있으며, 등록 성공 시 `ResultSUCCESS`가, 실패 시 `ResultFAIL` 이 반환됩니다.
- (void)registerPlaceEngineDelegate {
    if ([Plengi setDelegate:self] != ResultSUCCESS) {
        [self customAlertWithTitle:@"초기화에 실패하였습니다."
                           message:@"Plengi.setDelegate() 메소드에서 FAILED를 반환했습니다."];
    }
}

- (void)startSDK {
    if (![self locationAgreement])
    {
        [self customAlertWithTitle:@"SDK를 시작할 수 없음"
                           message:@"사용자 위치정보 동의가 필요합니다."];
    }
    else if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        [self customAlertWithTitle:@"SDK를 시작할 수 없음"
                           message:@"위치 권한이 필요합니다."];
    }
    else if ([Plengi start] != ResultSUCCESS) {
        [self customAlertWithTitle:@"SDK를 시작할 수 없음"
                           message:@"초기화, iOS버전 등을 확인해보세요."];
    }
    
    [self reloadStatusSectionFooter];
}

- (void)stopSDK:(BOOL)alert {
    if ([Plengi stop] != ResultSUCCESS) {
        if (alert) {
            [self customAlertWithTitle:@"SDK를 중단할 수 없음"
                               message:@"초기화, iOS버전 등을 확인해보세요."];
        }
    }
    
    [self reloadStatusSectionFooter];
}

- (void)reloadStatusSectionFooter {
    _engineStatusSection.footerTitle = [self engineStatusMessage];
    [self.tableView reloadData];
}

- (void)refreshPlace {
    if ([Plengi manual_refreshPlace_foreground] != ResultSUCCESS) {
        [self customAlertWithTitle:@"장소 요청을 할 수 없음"
                           message:@"초기화, iOS버전 등을 확인해보세요."];
    }
}

- (void)customAlertWithTitle:(NSString*)title
                     message:(NSString*)message {
    [self customAlertWithTitle:title
                       message:message
                        action:@"확인"
                        cancel:nil
                       handler:nil];
}

- (void)customAlertWithTitle:(NSString*)title
                     message:(NSString*)message
                      action:(NSString*)action
                      cancel:(NSString*)cancel
                     handler:(void(^)(void))handler {
    dispatch_async(dispatch_get_main_queue(), ^{
        PopupDialog *popupDialog = [[PopupDialog alloc] initWithTitle:title
                                                              message:message
                                                                image:nil
                                                      buttonAlignment:UILayoutConstraintAxisVertical
                                                      transitionStyle:PopupDialogTransitionStyleBounceUp
                                                       preferredWidth:340
                                                  tapGestureDismissal:YES
                                                  panGestureDismissal:YES
                                                        hideStatusBar:NO
                                                           completion:nil];
        if (cancel) {
            CancelButton *cancelButton = [[CancelButton alloc] initWithTitle:cancel
                                                                      height:45
                                                                dismissOnTap:YES
                                                                      action:nil];
            [popupDialog addButton:cancelButton];
        }
        
        DefaultButton *ok = [[DefaultButton alloc] initWithTitle:action
                                                          height:45
                                                    dismissOnTap:YES
                                                          action:^{
                                                              if (handler) {
                                                                  handler();
                                                              }
                                                          }];
        [popupDialog addButton:ok];
        
        [self presentViewController:popupDialog
                           animated:YES
                         completion:nil];
    });
}

- (void)enableGravity:(UISwitch*)sender {
    if (sender.isOn && ![self marketingAgreement]) {
        [self setEnableGravity:NO];
        [self customAlertWithTitle:@"Gravity를 사용할 수 없음"
                           message:@"사용자 마케팅 동의가 필요합니다."];
    }
    else {
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
                    [self setEnableGravity:NO];
                    [self customAlertWithTitle:@"Gravity를 사용할 수 없음"
                                       message:@"알림 권한이 필요합니다."];
                }
            }];
        }
        else {
            if (!UIApplication.sharedApplication.isRegisteredForRemoteNotifications) {
                [self setEnableGravity:NO];
                [self customAlertWithTitle:@"Gravity를 사용할 수 없음"
                                   message:@"알림 권한이 필요합니다."];
            }
        }
    }
    [Plengi enableAdNetwork:[self enableGravity]
                 enableNoti:YES];
}

- (void)marketingAgreement:(UISwitch*)sender {
    if ([self enableGravity] && ![self marketingAgreement]) {
        [self setEnableGravity:NO];
        [self customAlertWithTitle:@"Gravity를 사용할 수 없음"
                           message:@"Gravity 기능을 끕니다."];
    }
    [Plengi enableAdNetwork:[self enableGravity]
                 enableNoti:YES];
}

- (void)locationAgreement:(UISwitch*)sender {
    if (![self locationAgreement] && [Plengi getEngineStatus] == EngineStatusSTARTED) {
        [self stopSDK:NO];
        [self customAlertWithTitle:@"SDK를 사용할 수 없음"
                           message:@"SDK를 중단합니다."];
    }
}

/// 로플랫 SDK에서 장소 인식 등 서버로부터 응답이 온 경우, 해당 Delegate가 호출됩니다.
- (void)responsePlaceEvent:(PlengiResponse *)plengiResponse {
    NSString* title = @"Plengi Response : ";
    NSString* message = @"";
    
    if (plengiResponse.echoCode != nil) {
        message = [message stringByAppendingFormat:@"Echo code : %@", plengiResponse.echoCode];
    }

    if ([plengiResponse result] == ResultSUCCESS) {
        Place*     place = plengiResponse.place;
        Area*       area = plengiResponse.area;
        Complex* complex = plengiResponse.complex;
        
        if (place != nil) {
            title = [title stringByAppendingString:place.name];
            message = [message stringByAppendingString:@"\nplaceEvent : "];
            if ([plengiResponse placeEvent] == PlaceEventENTER) {
                // 사용자가 장소에 들어왔을 때
                message = [message stringByAppendingString:@"ENTER"];
            } else if ([plengiResponse placeEvent] == PlaceEventNEARBY) {
                // NEARBY로 인식되었을 때
                message = [message stringByAppendingString:@"NEARBY"];
            } else if ([plengiResponse placeEvent] == PlaceEventLEAVE) {
                // 사용자가 장소를 떠났을 때
                message = [message stringByAppendingString:@"LEAVE"];
            }
            message = [message stringByAppendingFormat:@"\nID : %td \nAddress_road : %@", place.loplat_id, place.address_road];
        }
        else if (area != nil) {
            // 상권이 인식되었을 때
            title = [title stringByAppendingString:area.name];
            message = [message stringByAppendingFormat:@"\nID : %td \nlat : %f \nlng : %f", area.id, area.lat, area.lng];
        }
        else if (complex != nil) {
            // 복합몰이 인식되었을 때
            title = [title stringByAppendingString:complex.name];
            message = [message stringByAppendingFormat:@"\nID : %td \nBranch name: %@", complex.id, complex.branch_name];
        }
    }
    else {
        /* 여기서부터는 오류인 경우입니다 */
        // [plengiResponse errorReason] 에 위치 인식 실패 / 오류 이유가 포함됨
        
        // FAIL : 위치 인식 실패
        // NETWORK_FAIL : 네트워크 오류
        // ERROR_CLOUD_ACCESS : 클라이언트 ID/PW가 틀렸거나 인증되지 않은 사용자가 요청했을 때
        title = [title stringByAppendingString:@"Error"];
        NSString* errorReason = plengiResponse.errorReason;
        if (errorReason == nil) {
            errorReason = @"NONE";
        }
        message = [message stringByAppendingFormat:@"\nReason : %@", errorReason];
    }
    
    [self customAlertWithTitle:title
                       message:message];
}

@end
