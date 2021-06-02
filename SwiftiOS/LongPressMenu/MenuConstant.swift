//
//  MenuConstant.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/2.
//

import UIKit

struct MenuStyle {
    
    enum ArrowDirection {
        case top
        case bottom
    }
    
    /// 每个单元格size
    let size: CGSize
    
    /// 箭头方向
    let arrowDirection: ArrowDirection
    
    /// 每行最多几个
    let max: Int
    
    /// 内边距
    let inset: UIEdgeInsets
    
    /// 箭头高度
    let arrowSpace: CGFloat = 20
    
    /// 水平方向最小边距
    let horizontalMiniSpace: CGFloat = 20
}

extension MenuStyle {
    
    static let vertical = MenuStyle(size: CGSize(width: 100, height: 50), arrowDirection: .top, max: 1, inset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    
    static let horizontal = MenuStyle(size: CGSize(width: 100, height: 50), arrowDirection: .bottom, max: 5, inset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
}
