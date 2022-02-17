//
//  AppDelegate.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.08.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let statusBar1 =  UIView()
//        statusBar1.frame = UIApplication.shared.statusBarFrame
//        statusBar1.backgroundColor = UIColor.init(hex: "#2E8EEF")
//        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.keyWindow?.addSubview(statusBar1)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
