//
//  AppDelegate.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/1.
//

import UIKit
import FluentDarkModeKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        MethodSwizzling.setup()
//        DatabaseManager.shared.setup()
        AppRouter.shared.register(path: .main, navigator: MainNavigator())
        AppRouter.shared.register(path: .test, navigator: MainNavigator())
        return true
    }


}

