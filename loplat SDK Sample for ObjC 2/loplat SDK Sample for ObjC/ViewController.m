//
//  ViewController.m
//  loplat SDK Sample for ObjC
//
//  Created by 상훈 on 01/08/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.titleText.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:20.0];
    self.summaryText.font = [UIFont systemFontOfSize:13.0];
    
    [self.okButton addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okButtonClicked:(UIButton*)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
