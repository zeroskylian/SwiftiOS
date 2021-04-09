//
//  AppRouter.swift
//  Moments
//
//  Created by Jake Lin on 17/10/20.
//

import UIKit

public final class AppRouter: AppRouting {
    
    static let shared: AppRouter = .init()

    private var navigators: [NavigatorPath: Navigator] = [:]

    private init() {}
    
    public func register(path: NavigatorPath, navigator: Navigator) {
        navigators[path] = navigator
    }
    
    public func route(to url: URL?, from routingSource: RoutingSource?, userInfo: [AppRoutingInfoKey: Any]? = nil, using transitionType: TransitionType = .present) {
        guard let url = url, let sourceViewController = routingSource as? UIViewController ?? UIViewController.topMost else { return }
        let path = NavigatorPath(rawValue: url.lastPathComponent)
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        var parameters: [AppRoutingInfoKey: Any] = (urlComponents.queryItems ?? []).reduce(into: [:]) { params, queryItem in
            let key = AppRoutingInfoKey(rawValue: queryItem.name.lowercased())
            params[key] = queryItem.value
        }
        if let userInfo = userInfo {
            parameters += userInfo
        }
        navigators[path]?.navigate(from: sourceViewController, using: transitionType, parameters: parameters)
    }
}
