//
//  MenuView.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/2.
//

import UIKit

class MenuView: UIView {
    
    static func show(from sender: UIView, style: MenuStyle, items: [MenuItem]) {
        let menu = MenuView(sender: sender, style: style, items: items)
        menu.show()
    }
    
    /// 背景视图
    private(set) lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    let sender: UIView
    
    let container: MenuItemContainer
    
    let arrowView: UIView = {
        let arrowView = UIView()
        arrowView.layer.cornerRadius = 4
        arrowView.clipsToBounds = true
        return arrowView
    }()
    
    let style: MenuStyle
    
    init(sender: UIView,style: MenuStyle, items: [MenuItem]) {
        self.sender = sender
        self.style = style
        container = MenuItemContainer(style: style, items: items)
        super.init(frame: UIScreen.main.bounds)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(backgroundView)
        addSubview(arrowView)
        backgroundView.frame = bounds
        
        arrowView.addSubview(container)
        let rect = convert(sender.frame, to: self)
        let containerSize = container.calculateSize()
        let arrowSize = CGSize(width: containerSize.width, height: containerSize.height + style.arrowSpace)
        let anchorPoints = CGPoint(x: max(style.horizontalMiniSpace, rect.minX + rect.width / 2.0 - arrowSize.width / 2.0), y: rect.maxY)
        let arrowRect: CGRect = CGRect(origin: anchorPoints, size: arrowSize)
        arrowView.frame = arrowRect
        container.frame = CGRect(x: 0, y: style.arrowSpace, width: containerSize.width, height: containerSize.height)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        backgroundView.addGestureRecognizer(tap)
        
        
        arrowView.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        guard let keyWindow = keyWindow() else { return }
        keyWindow.addSubview(self)
    }
    
    
    func keyWindow() -> UIWindow? {
        var originalKeyWindow : UIWindow? = nil
        
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            originalKeyWindow = UIApplication.shared.keyWindow
        }
        #else
        originalKeyWindow = UIApplication.shared.keyWindow
        #endif
        return originalKeyWindow
    }
    
    @objc private func tapGestureAction(_ tap: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
    deinit {
        print("deinit === meun")
    }
}
