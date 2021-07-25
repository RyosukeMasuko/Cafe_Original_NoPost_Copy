//
//  AppDelegate.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/09.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let applicationKey = "3e996d179e32fb33a7ab8e3424bc46b140e160198e6f2d02e0fa6d20ed20446b"
        let clientKey = "79f5f88d8abcf1609c177a1358a37d9efdf0be71b3534cb06c44283b1d24f08b"
        NCMB.setApplicationKey(applicationKey, clientKey: clientKey)
        
        SVProgressHUD.setOffsetFromCenter(
            UIOffset(horizontal: UIScreen.main.bounds.width/2,
            vertical: UIScreen.main.bounds.height/2)
        )
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

