//
//  NavigatorRouter.swift
//  HengLiMarketing
//
//  Created by lian on 2021/4/7.
//

import UIKit

public protocol NavigatorRouterProtocol where Self: UIViewController {
    
    func adapterDefaultParameter(parameter: [AppRoutingInfoKey: Any])
    
    func setParameter(json: [String: Any]?)
    
    func setParameter(interact: Any?)
    
    func setParameter(object: Any?)
    
    func setParameter(list: [Any]?)
}

extension NavigatorRouterProtocol {
    
    func adapterDefaultParameter(parameter: [AppRoutingInfoKey: Any]) {
        if let json = parameter[.json] as? [String: Any] {
            setParameter(json: json)
        }
        
        if let interact = parameter[.interact] {
            setParameter(interact: interact)
        }
        
        if let object = parameter[.object] {
            setParameter(object: object)
        }
        
        if let list = parameter[.list] as? [Any] {
            setParameter(list: list)
        }
    }
}
