//
//  ViewController.m
//  LoplatSampleApp
//
//  Created by hieonn on 2016. 5. 25..
//  Copyright © 2016년 HANDSOME COMPANY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize WebView,startbtn,stopbtn,currentPlacebtn,running;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    running=YES;
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.delegate=self;
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *urlString=[NSString stringWithFormat:@"http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle=%@",bundleIdentifier];
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)start:(id)sender{
    
    if(self.running){
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.loplat stop];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"STOP"
                                                                       message:@"로플렛을 종료합니다."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"확인"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:NO completion:nil];
                                                              }];
        
        [alert addAction:firstAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        self.running=NO;
        [self.startbtn setTitle:@"START" forState:UIControlStateNormal];
        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        app.loplat=[Loplat getLoplat:@"test" client_secret:@"test" is_return_mainthread:NO];
        
        [app.loplat startLocationUpdate:180];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"START"
                                                                       message:@"로플렛을 시작합니다."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"확인"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:NO completion:nil];
                                                              }];
        
        [alert addAction:firstAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        self.running=YES;
        [self.startbtn setTitle:@"STOP" forState:UIControlStateNormal];
    }
    
    }

-(IBAction)stop:(id)sender{
    
}

-(IBAction)currentPlace:(id)sender{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(app.loplat==nil){
        app.loplat=[Loplat getLoplat:@"test" client_secret:@"test" is_return_mainthread:NO];
    }
    
    NSDictionary *place=[app.loplat getCurrentPlace];
    
    UIAlertController *alert;
    if([place objectForKey:@"place"]!=nil){
    
        NSString *name=[[place objectForKey:@"place"] objectForKey:@"name"];
        float accuary=[[[place objectForKey:@"place"] valueForKey:@"accuracy"]floatValue];
        float threshold=[[[place objectForKey:@"place"] valueForKey:@"threshold"]floatValue];
        if(accuary<threshold){
            name=[name stringByAppendingString:@"근처"];
        }

        
        
    alert = [UIAlertController alertControllerWithTitle:@"현재위치"
                                                message:name
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    }else{
        alert = [UIAlertController alertControllerWithTitle:@"현재위치"
                                                    message:@"wifi 환경이 아니거나 등록된 위치가 아닙니다."
                                             preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"확인"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:NO completion:nil];
                                                          }];
    [alert addAction:firstAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(IBAction)refresh:(id)sender{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *urlString=[NSString stringWithFormat:@"http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle=%@",bundleIdentifier];
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


-(void)refreshwebview{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *urlString=[NSString stringWithFormat:@"http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle=%@",bundleIdentifier];
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [super viewDidAppear:NO];
}

@end
