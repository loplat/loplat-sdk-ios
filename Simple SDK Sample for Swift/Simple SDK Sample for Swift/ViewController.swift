//
//  ViewController.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 2018. 9. 20..
//  Copyright © 2018년 Loplat. All rights reserved.
//

import UIKit
import CoreLocation

import MiniPlengi

class ViewController: UIViewController {
    static let locationManager = CLLocationManager()

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var  engineLabel: UILabel!
    
    @IBOutlet weak var marketingSwitch: UISwitch!
    @IBOutlet weak var  locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.locationManager.delegate = self
        
        Agreement.marketing.observeValue(on: true, sender: self)
        Agreement.location.observeValue(on: true, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Agreement.marketing.setIsOn()
        Agreement.location.setIsOn()
        
        if let info = Bundle(for: Plengi.self).infoDictionary {
            self.versionLabel.text = "SDK version : " + (info["CFBundleShortVersionString"] as? String ?? "")
        }
    }
    
    deinit {
        Agreement.marketing.observeValue(on: false, sender: self)
        Agreement.location.observeValue(on: false, sender: self)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        guard let agreemnet = Agreement(rawValue: keyPath) else {
            return
        }
        
        DispatchQueue.main.async {
            switch agreemnet {
            case .marketing:
                self.marketingSwitch.setOn(agreemnet.isOn , animated: true)
            case .location:
                self.locationSwitch.setOn(agreemnet.isOn , animated: true)
                self.engineLabel.text = "Engine is " + (Plengi.getEngineStatus() == .STARTED ? "started" : "stopped")
            }
        }
    }

    @IBAction func touchGetPlaceInfo(_ sender: UIButton) {
        _ = Plengi.manual_refreshPlace_foreground()
    }
    
    @IBAction func switchMarketing(_ sender: UISwitch) {
        Agreement.marketing.setIsOn(sender.isOn)
    }
    
    @IBAction func switchLocation(_ sender: UISwitch) {
        Agreement.location.setIsOn(sender.isOn)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if UserDefaults.standard.bool(forKey: "notDetermined") {
            UserDefaults.standard.set(false, forKey: "notDetermined")
            Agreement.location.setIsOn(true)
        }
        else {
            switch status {
            case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
                Agreement.location.setIsOn(false)
            case .authorizedAlways:
                print("do nothing")
            }
        }
    }
}
