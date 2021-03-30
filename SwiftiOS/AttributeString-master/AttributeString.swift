//
//  AttributeString.swift
//  UiOSProject
//
//  Created by 廉鑫博 on 2019/4/23.
//  Copyright © 2019 廉鑫博. All rights reserved.
//

import Foundation
import UIKit

////////////////////////////////////////////////////////////////////
//: ## Type Definition

struct AttributeString {
    let attributedString: NSAttributedString
}

extension AttributeString: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension AttributeString: CustomStringConvertible {
    var description: String {
        return String(describing: self.attributedString)
    }
}

////////////////////////////////////////////////////////////////////
//: ## StringInterpolation Support (Designated methods)

extension AttributeString: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString
        
        init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
        }
        
        func appendInterpolation(_ string: String, attributes: [NSAttributedString.Key: Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
    }
}

/*
 let user = "AliSoftware"
 let str: AttrString = """
 Hello \(user, attributes: [.foregroundColor: NSColor.blue])!
 """
 */

////////////////////////////////////////////////////////////////////
//: ## StringInterpolation : Style convenience methods

extension AttributeString {
    struct Style {
        
        let attributes: [NSAttributedString.Key: Any]
        
        /// 字体
        static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }
        
        /// 段落
        static func paraStyle(_ style:NSParagraphStyle) -> Style {
            return Style(attributes: [.paragraphStyle: style])
        }
        
        /// 文字颜色
        static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor: color])
        }
        
        /// 背景色
        static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor: color])
        }
        
        /// 文字分割距离
        static func kern(_ kern: CGFloat) -> Style {
            return Style(attributes: [.kern: kern])
        }
        
        /// 删除线 style 1 or 0
        static func strikethrough(_ style: CGFloat,_ color:UIColor) -> Style {
            return Style(attributes: [.strikethroughStyle: style,.strikethroughColor:color])
        }
        
        /// 底线
        static func underline(_ style: NSUnderlineStyle,_ color: UIColor) -> Style {
            return Style(attributes: [.underlineColor: color,.underlineStyle: style.rawValue])
        }
        
        /// 描边
        static func stroke(_ width: CGFloat,_ color:UIColor) -> Style {
            return Style(attributes: [.strokeWidth:width,.strokeColor:color])
        }
        
        /// 阴影
        static func shadow(_ shadow:NSShadow ) -> Style {
            return Style(attributes: [.shadow:shadow])
        }
        
        /// 文本特殊效果,目前只有图版印刷效果可用letterpressStyle
        static func textEffect(_ textEffect:NSAttributedString.TextEffectStyle = .letterpressStyle) -> Style {
            return Style(attributes: [.textEffect:textEffect])
        }
        
        /// 超链接
        static func link(_ link: URL) -> Style {
            return Style(attributes: [.link: link])
        }
        
        /// baselineOffset
        static func baselineOffset(_ offset: CGFloat) -> Style {
            return Style(attributes: [.baselineOffset: offset])
        }
        
        /// 字体倾斜度 ,正值右倾，负值左倾
        static func obliqueness(_ offset: CGFloat) -> Style {
            return Style(attributes: [.obliqueness: offset])
        }
        
        /// 置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
        static func expansion(_ expansion: CGFloat) -> Style {
            return Style(attributes: [.expansion: expansion])
        }
        
        /// 书写方向  应该是NSWritingDirection.RawValue 但是不起效果用0,1,2,3有用
        static func writingDirection(_ direction: [Int]) -> Style {
            return Style(attributes: [.writingDirection: direction])
        }
        
        // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
        static let verticalGlyphForm = Style(attributes: [.verticalGlyphForm: 0])
        
    }
}

/*
 // First try: support one Style
 extension AttrString.StringInterpolation {
 func appendInterpolation(_ string: String, _ style: AttrString.Style) {
 let astr = NSAttributedString(string: string, attributes: style.attributes)
 self.attributedString.append(astr)
 }
 }
 // But why not support multiple styles at once using variadic parameters instead? (see below)
 */

extension AttributeString.StringInterpolation {
    func appendInterpolation(_ string: String, _ style: AttributeString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        self.attributedString.append(astr)
    }
    
    func appendInterpolation(wrap string: AttributeString, _ style: AttributeString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        self.attributedString.append(mas)
    }
    
    func appendInterpolation(image: UIImage, scale: CGFloat = 1.0) {
        let attachment = NSTextAttachment()
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        attachment.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        attachment.image = image
        self.attributedString.append(NSAttributedString(attachment: attachment))
    }
}
