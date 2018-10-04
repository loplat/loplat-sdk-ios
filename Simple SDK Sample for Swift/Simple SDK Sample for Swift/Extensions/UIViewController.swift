//
//  UIViewController.swift
//  Simple SDK Sample for Swift
//
//  Created by KimByungChul on 02/10/2018.
//  Copyright © 2018 Loplat. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            if presented is UIAlertController {
                return self
            }
            else {
                return presented.topMostViewController()
            }
        }
        else if let splitViewController = self as? UISplitViewController {
            if let last = splitViewController.viewControllers.last {
                return last.topMostViewController()
            }
            else {
                return self
            }
        }
        else if let navigationController = self as? UINavigationController {
            if let top = navigationController.topViewController {
                return top.topMostViewController()
            }
            else {
                return self
            }
        }
        else if let tabBarController = self as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return selected.topMostViewController()
            }
            else {
                return self
            }
        }
        else {
            return self
        }
    }
}

