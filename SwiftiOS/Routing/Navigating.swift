//
//  Navigating.swift
//  Moments
//
//  Created by Jake Lin on 3/2/21.
//

import UIKit

public protocol Navigator {
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [AppRoutingInfoKey: Any])
}

public extension Navigator {
    func navigate(to destinationViewController: UIViewController, from sourceViewController: UIViewController, using transitionType: TransitionType) {
        switch transitionType {
        case .show:
            sourceViewController.show(destinationViewController, sender: nil)
        case .present:
            sourceViewController.present(destinationViewController, animated: true)
        }
    }
}
