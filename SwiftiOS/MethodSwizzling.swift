//
//  MethodSwizzling.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/3.
//

import Foundation
import UIKit


class MethodSwizzling {
    
    static let shared: MethodSwizzling = MethodSwizzling()
    
    fileprivate static var swizzlingConfigured = false
    
    private init() {}
    
    public static func setup() {
        guard !swizzlingConfigured else { return }
        defer { swizzlingConfigured = true }
        UIViewController.swizzleViewDidAppear
        UIViewController.swizzleViewDidDisappear
        UIControl.swizzleSendAction
    }
}

private func swizzleFailed(class cls: AnyClass, selector: Selector ) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
}

private func addLog(target: UIViewController, action: Selector,actionType: String?) {
    addLog(target: target, action: String(describing: action), actionType: actionType)
}

private func addLog(target: UIViewController, action: String, actionType: String?) {
    var log : [String : String] = [:]
    if let title = target.title {
        log["target"] = title
    }else {
        log["target"] = String(describing: type(of: target))
    }
    log["action"] = action
    log["actionType"] = actionType
    print(log)
}

extension UIViewController {
    
    static let swizzleViewDidAppear: Void = {
        let selector = #selector(UIViewController.viewDidAppear(_:))
        guard let method = class_getInstanceMethod(UIViewController.self, selector) else {
            assertionFailure(swizzleFailed(class: UIViewController.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UIViewController.self, selector, imp_implementationWithBlock({(self: UIViewController, animated: Bool) -> Void in
            addLog(target: self, action: selector, actionType: nil)
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIViewController, Selector, Bool) -> Void).self)
            oldIMP(self,selector,animated)
        } as @convention(block) (UIViewController, Bool) -> Void) , method_getTypeEncoding(method))
    }()
    
    static let swizzleViewDidDisappear: Void = {
        let selector = #selector(UIViewController.viewDidDisappear(_:))
        guard let method = class_getInstanceMethod(UIViewController.self, selector) else {
            assertionFailure(swizzleFailed(class: UIViewController.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UIViewController.self, selector, imp_implementationWithBlock({(self: UIViewController, animated: Bool) -> Void in
            addLog(target: self, action: selector, actionType: nil)
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIViewController, Selector, Bool) -> Void).self)
            oldIMP(self,selector,animated)
        } as @convention(block) (UIViewController, Bool) -> Void) , method_getTypeEncoding(method))
    }()
}

extension UIControl {
    
    static let swizzleSendAction: Void = {
        /// open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?)
        let selector = #selector(UIControl.sendAction(_:to:for:))
        guard let method = class_getInstanceMethod(UIControl.self, selector) else {
            assertionFailure(swizzleFailed(class: UIControl.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UIControl.self, selector, imp_implementationWithBlock({(self: UIControl, action: Selector, target: Any? ,event: UIEvent?) -> Void in
            if let vc = self.findViewController() {
                addLog(target: vc, action: action, actionType: "Button")
            }
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIControl, Selector, Selector, Any?, UIEvent?) -> Void ).self)
            oldIMP(self,selector,action,target,event)
        } as @convention(block) (UIControl, Selector, Any?, UIEvent?) -> Void), method_getTypeEncoding(method))
    }()
}

extension UIView {
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
