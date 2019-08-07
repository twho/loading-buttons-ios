//
//  AppDelegate.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/4/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let view = MainViewController()
        self.window!.rootViewController = view
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

