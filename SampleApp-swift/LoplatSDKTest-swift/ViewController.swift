//
//  ViewController.swift
//  LoplatSDKTest-swift
//
//  Created by mac on 2016. 5. 20..
//  Copyright © 2016년 hansomecompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var webview : UIWebView!
    @IBOutlet var startbtn : UIButton!
    @IBOutlet var refreshbtn : UIButton!
    @IBOutlet var currentplacebtn : UIButton!
    var running : Bool!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundleID : String = NSBundle.mainBundle().bundleIdentifier!
        let url : String = "http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle="+bundleID
        webview.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        
        startbtn.addTarget(self, action : #selector(ViewController.start(_:)), forControlEvents: UIControlEvents.TouchDown)
        refreshbtn.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: UIControlEvents.TouchDown)
        currentplacebtn.addTarget(self, action: #selector(ViewController.currentplace(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        
        running = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        let bundleID : String = NSBundle.mainBundle().bundleIdentifier!
        let url : String = "http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle="+bundleID
        webview.loadRequest(NSURLRequest(URL: NSURL(string: url)!))

    }
    

    func start(sender : UIButton){
        if(running==true){
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            app.loplat.stop()

            let alert = UIAlertController(title: "STOP", message: "로플렛을 일시 중지합니다.", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            alert.addAction(okAction)
            
            startbtn.setTitle("START", forState:UIControlState.Normal)
            
            self.presentViewController(alert, animated: true, completion: nil)
            running=false;
        }else{
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if((app.loplat == nil)){
                app.loplat=Loplat.getLoplat("test", client_secret:"test")
            }
            
            app.loplat.startLocationUpdate(180)
            
            
            let alert = UIAlertController(title: "START", message: "로플렛을 다시 시작합니다.", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            alert.addAction(okAction)
            
            startbtn.setTitle("STOP", forState:UIControlState.Normal)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            running = true
        }
    }
    
    func refresh(sender : UIButton){
        let bundleID : String = NSBundle.mainBundle().bundleIdentifier!
        let url : String = "http://i-handsome.com/tc/loplat/bssid_db_check.php?bundle="+bundleID
        webview.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }
    
    func currentplace(sender :UIButton){
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if((app.loplat == nil)){
            app.loplat=Loplat.getLoplat("test", client_secret:"test")
        }
        
        let name = app.loplat.getCurrentPlace()["place"]!["name"] as! String
        
        
        if(name.isEmpty){
        let alert = UIAlertController(title: "현재위치", message: "wifi환경이 아니거나 등록된 위치가 아닙니다.", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            alert.addAction(okAction)
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "현재위치", message: name, preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
}

