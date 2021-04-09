//
//  File.swift
//  Moments
//
//  Created by Jake Lin on 3/2/21.
//

import UIKit

public struct AppRoutingInfoKey: RawRepresentable, Hashable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue.lowercased()
    }
}

public protocol AppRouting {
    func register(path: NavigatorPath, navigator: Navigator)
    func route(to url: URL?, from routingSource: RoutingSource?, userInfo: [AppRoutingInfoKey: Any]?, using transitionType: TransitionType)
}
