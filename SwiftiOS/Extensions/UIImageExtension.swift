//
//  UIImageExtension.swift
//  SwiftiOS
//
//  Created by lian on 2021/6/21.
//

import UIKit
import func AVFoundation.AVMakeRect

extension UIImage {
    
    enum Scale {
        case auto(CGFloat)
        case width(CGFloat)
        case height(CGFloat)
        case size(CGSize)
    }
    
    
    /// 根据约束缩放图片
    /// - Parameters:
    ///   - constraint: 约束
    ///   - scaleFactor: 缩放因子
    /// - Returns: 图片
    func redraw(scale: Scale, scaleFactor: CGFloat! = UIScreen.main.scale) -> UIImage? {
        let size = scaleSize(scale: scale)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: size))
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaleSize = rect.size.applying(transform)
        let renderer = UIGraphicsImageRenderer(size: scaleSize)
        return renderer.image { (context) in
            draw(in: CGRect(origin: .zero, size: scaleSize))
        }
    }
    
    
    /// 根据约束计算缩放后的大小
    /// - Parameter constraint: 约束类型
    /// - Returns: size
    func scaleSize(scale: Scale) -> CGSize {
        switch scale {
        case .width(let width):
            return CGSize(width: width, height: self.size.width / width * self.size.height)
        case .height(let height):
            return CGSize(width: self.size.height / height * self.size.width, height: height)
        case .size(let size):
            let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: size))
            return rect.size
        case .auto(let auto):
            if size.width > size.height {
                return scaleSize(scale: .width(auto))
            } else {
                return scaleSize(scale: .height(auto))
            }
        }
    }
}
