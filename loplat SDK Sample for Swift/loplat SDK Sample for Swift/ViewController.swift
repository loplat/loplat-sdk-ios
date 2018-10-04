//
//  ViewController.swift
//  loplat SDK Sample for Swift
//
//  Created by 상훈 on 31/07/2018.
//  Copyright © 2018 loplat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var titleText: UILabel? = nil
    @IBOutlet private weak var summaryText: UILabel? = nil
    @IBOutlet private weak var okButton: UIButton? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /// 필수 UI 구성요소를 초기화합니다.
    private func initView() {
        self.titleText?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20.0)!
        self.summaryText?.font = UIFont.systemFont(ofSize: 13.0)
        
        okButton?.addTarget(self, action: #selector(self.okButtonClicked), for: .touchUpInside)
    }
    
    @objc private func okButtonClicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

