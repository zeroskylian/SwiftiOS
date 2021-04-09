//
//  MainVC.swift
//  SwiftiOS
//
//  Created by lian on 2021/4/9.
//

import UIKit

class MainVC: UIViewController {
    
    let lb = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension MainVC: NavigatorRouterProtocol {
    
    public func setParameter(json: [String: Any]?) {
        HLLog(message: json, type: .database)
    }
    
    public func setParameter(interact: Any?) {
        HLLog(message: interact, type: .database)
    }
    
    public func setParameter(object: Any?) {
        HLLog(message: object, type: .database)
        if let title = object as? String {
            self.title = title
        }
    }
    
    public func setParameter(list: [Any]?) {
        HLLog(message: list, type: .database)
    }
}
