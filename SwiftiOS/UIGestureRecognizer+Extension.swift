//
//  UIGestureRecognizer+Extension.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/3.
//

import UIKit

private var UIGestureRecognizerMethodKey: Void?
extension UIGestureRecognizer {
    
    var method: String? {
        set {
            objc_setAssociatedObject(self, &UIGestureRecognizerMethodKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &UIGestureRecognizerMethodKey) as? String
        }
    }
}
