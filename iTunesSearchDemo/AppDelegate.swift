//
//  AppDelegate.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = SearchViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
