//
//  TestRouter.swift
//  SwiftiOS
//
//  Created by lian on 2021/4/9.
//

import UIKit

public extension AppRoutingInfoKey {
    
    static let object = AppRoutingInfoKey(rawValue: "Parameter.object")
    
    static let json = AppRoutingInfoKey(rawValue: "Parameter.json")
    
    static let list = AppRoutingInfoKey(rawValue: "Parameter.list")
    
    static let interact = AppRoutingInfoKey(rawValue: "Parameter.interact")
}

extension NavigatorPath {
    
    public static let main = NavigatorPath(rawValue: "main")
    
    public static let test = NavigatorPath(rawValue: "test")
    
    public struct Main {
        public static let user = NavigatorPath(rawValue: "main/user")
    }
    
}
struct DefaultNavigator: Navigator {
    
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [AppRoutingInfoKey : Any]) {
        /// 404
    }
    
    
}

public struct MainNavigator: Navigator {
    
    public func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [AppRoutingInfoKey : Any]) {
        let destinationViewController = MainVC()
        destinationViewController.adapterDefaultParameter(parameter: parameters)
        navigate(to: destinationViewController, from: viewController, using: .show)
    }
}

