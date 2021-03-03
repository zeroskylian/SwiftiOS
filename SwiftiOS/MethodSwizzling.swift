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
        UIView.swizzleAddGesture
        UITableView.swizzleDelegate
        UICollectionView.swizzleDelegate
    }
}

private func swizzleFailed(class cls: AnyClass, selector: Selector ) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
}

private func addLog(target: AnyClass, action: Selector,type: String?) {
    addLog(target: target, action: String(describing: action), type: type)
}

private func addLog(target: AnyClass, action: String,type: String?) {
    var log : [String : String] = [:]
    log["target"] = String(describing: target)
    log["action"] = action
    log["type"] = type
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
            addLog(target: type(of: self), action: selector, type: nil)
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
            addLog(target: type(of: self), action: selector, type: nil)
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
            if let target = target {
                addLog(target: type(of: target as AnyObject), action: action, type: "Button")
            }
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIControl, Selector, Selector, Any?, UIEvent?) -> Void ).self)
            oldIMP(self,selector,action,target,event)
        } as @convention(block) (UIControl, Selector, Any?, UIEvent?) -> Void), method_getTypeEncoding(method))
    }()
}

extension UIView {
    
    static let swizzleAddGesture: Void = {
        /// open func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
        let selector = #selector(UIView.addGestureRecognizer(_:))
        guard let method = class_getInstanceMethod(UIView.self, selector) else {
            assertionFailure(swizzleFailed(class: UIView.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UIView.self, selector, imp_implementationWithBlock({ (self: UIView, gestureRecognizer: UIGestureRecognizer) -> Void in
            if gestureRecognizer is UITapGestureRecognizer {
                gestureRecognizer.addTarget(self, action: #selector(trigger(gesture:)))
            }
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIView, Selector, UIGestureRecognizer) -> Void ).self)
            oldIMP(self,selector,gestureRecognizer)
        } as @convention(block) (UIView, UIGestureRecognizer) -> Void), method_getTypeEncoding(method))
    }()
    
    @objc func trigger(gesture: UITapGestureRecognizer) {
        guard let vc = findViewController(),let view = gesture.view else {
            return
        }
        addLog(target: type(of: vc), action: "Tap", type: String(describing: type(of: view)))
    }
    
    
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
extension UITableView {
    
    static let swizzleDelegate: Void = {
        let selector = #selector(setter: delegate)
        guard let method = class_getInstanceMethod(UITableView.self, selector) else {
            assertionFailure(swizzleFailed(class: UITableView.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UITableView.self, selector, imp_implementationWithBlock({(self: UITableView, delegate: UITableViewDelegate?) -> Void in
            if let delegate = delegate {
                swizzleTableViewDelegateDidSelect(delegate: delegate)
            }
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UITableView, Selector, UITableViewDelegate?) -> Void).self)
            oldIMP(self,selector,delegate)
        } as @convention(block) (UITableView, UITableViewDelegate?) -> Void), method_getTypeEncoding(method))
    }()
    
    
    static func swizzleTableViewDelegateDidSelect(delegate: UITableViewDelegate) {
        /// optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
        guard delegate.responds(to: selector)  else { return }
        guard let method = class_getInstanceMethod(type(of: delegate), selector) else {
            assertionFailure(swizzleFailed(class: UITableViewDelegate.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(type(of: delegate), selector, imp_implementationWithBlock({(self:UITableViewDelegate, tableView: UITableView,indexPath: IndexPath) -> Void in
            addLog(target: type(of: self), action: String(describing: indexPath), type: "TableView")
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UITableViewDelegate, Selector, UITableView, IndexPath) -> Void).self)
            oldIMP(self,selector,tableView,indexPath)
        } as @convention(block) (UITableViewDelegate, UITableView, IndexPath) -> Void), method_getTypeEncoding(method))
    }
}


extension UICollectionView {
    
    static let swizzleDelegate: Void = {
        let selector = #selector(setter: delegate)
        guard let method = class_getInstanceMethod(UICollectionView.self, selector) else {
            assertionFailure(swizzleFailed(class: UICollectionView.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(UICollectionView.self, selector, imp_implementationWithBlock({(self: UICollectionView, delegate: UICollectionViewDelegate?) -> Void in
            if let delegate = delegate {
                swizzleCollectionViewDelegateDidSelect(delegate: delegate)
            }
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UICollectionView, Selector, UICollectionViewDelegate?) -> Void).self)
            oldIMP(self,selector,delegate)
        } as @convention(block) (UICollectionView, UICollectionViewDelegate?) -> Void), method_getTypeEncoding(method))
    }()
    
    static func swizzleCollectionViewDelegateDidSelect(delegate: UICollectionViewDelegate) {
        //        optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        let selector = #selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:))
        guard delegate.responds(to: selector)  else { return }
        guard let method = class_getInstanceMethod(type(of: delegate), selector) else {
            assertionFailure(swizzleFailed(class: UICollectionViewDelegate.self, selector: selector))
            return
        }
        let imp = method_getImplementation(method)
        class_replaceMethod(type(of: delegate), selector, imp_implementationWithBlock({ (self:UICollectionViewDelegate, collectionView: UICollectionView,indexPath: IndexPath) -> Void in
            addLog(target: type(of: self), action: String(describing: indexPath), type: "CollectionView")
            let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UICollectionViewDelegate, Selector, UICollectionView, IndexPath) -> Void).self)
            oldIMP(self,selector,collectionView,indexPath)
        } as @convention(block) (UICollectionViewDelegate, UICollectionView, IndexPath) -> Void), method_getTypeEncoding(method))
    }
}

//extension UIGestureRecognizer {
//    // public init(target: Any?, action: Selector?)
//    static let swizzleInit: Void = {
//        let selector = #selector(UIGestureRecognizer.init(target:action:))
//        guard let method = class_getInstanceMethod(UIGestureRecognizer.self, selector) else {
//            assertionFailure(swizzleFailed(class: UICollectionView.self, selector: selector))
//            return
//        }
//        let imp = method_getImplementation(method)
//        class_replaceMethod(UIGestureRecognizer.self, selector, imp_implementationWithBlock({(self: UIGestureRecognizer, target: Any?, action: Selector?) -> Void in
//            if self is UITapGestureRecognizer {
//
//            }
//
//            let oldImp = unsafeBitCast(imp, to: (@convention(c) (UIGestureRecognizer, Selector, Any?, Selector?) -> Void).self)
//            oldImp(self,selector,target,action)
//        } as @convention(block)(UIGestureRecognizer, Any?, Selector?) -> Void), method_getTypeEncoding(method))
//    }()
//}
