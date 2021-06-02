//
//  RoutingSource.swift
//  Moments
//
//  Created by Jake Lin on 4/2/21.
//

import UIKit

public protocol RoutingSource: AnyObject {}

public typealias RoutingSourceProvider = () -> RoutingSource?

extension UIViewController: RoutingSource {}


