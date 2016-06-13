//
//  AppDelegate.swift
//  LoplatSDKTest-swift
//
//  Created by mac on 2016. 5. 20..
//  Copyright © 2016년 hansomecompany. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,LoplatDelegate {

    var window: UIWindow?

    var loplat:Loplat!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        loplat = Loplat.getLoplat("test",client_secret: "test")
        loplat.startLocationUpdate(180);
        loplat.delegate=self
        
        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func DidLoplatReport(result: [NSObject : AnyObject]!) {
        
        
    }
    
    func DidEnterPlace(currentPlace: [NSObject : AnyObject]!) {
        
        var name = currentPlace["name"] as! String

        var bssid = ""
        
        if let interfaces:CFArray! = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    bssid = interfaceData["BSSID"] as! String
                }
            }
        }
        
        if(bssid.isEmpty){
            bssid="00:00:00:00:00:00"
        }else{
            bssid=self.bssidTo12Digit(bssid)
        }

        
        
        let bundleID = NSBundle.mainBundle().bundleIdentifier
        
        name=name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        let urlStr = String(format : "http://i-handsome.com/tc/loplat/bssid_report.php?bssid=%@&category=1&bundle=%@&placename=%@",bssid,bundleID!,name)
        
        let url = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 5
        
        NSURLConnection.sendAsynchronousRequest(request,queue: NSOperationQueue.mainQueue()) {(response, data, error) in
        }
    }
    
    func DidLeavePlace(previousPlace: [NSObject : AnyObject]!) {
        var name = previousPlace["name"] as! String
        
        var bssid = ""
        
        if let interfaces:CFArray! = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    bssid = interfaceData["BSSID"] as! String
                }
            }
        }
        
        if(bssid.isEmpty){
            bssid="00:00:00:00:00:00"
        }else{
            bssid=self.bssidTo12Digit(bssid)
        }
        
        let bundleID = NSBundle.mainBundle().bundleIdentifier
        
        name=name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        let urlStr = String(format : "http://i-handsome.com/tc/loplat/bssid_report.php?bssid=%@&category=2&bundle=%@&placename=%@",bssid,bundleID!,name)
        
        let url = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 5
        
        NSURLConnection.sendAsynchronousRequest(request,queue: NSOperationQueue.mainQueue()) {(response, data, error) in
        }
    }

    func bssidTo12Digit(bssid : String) -> String {
        
        
        let strings = bssid.componentsSeparatedByString(":")
        var result : String = ""
        
        
        for i in 0  ..< strings.count  {
            var token : String = strings[i]
            if(token.characters.count==1){
                token="0"+token
            }
            if(i != strings.count-1){
                token=token+":"
            }
            
            result=result+token
        }
        return result
        
    }


}

