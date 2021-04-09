//
//  Navigator.swift
//  SwiftiOS
//
//  Created by lian on 2021/4/9.
//

import UIKit


public struct NavigatorPath: RawRepresentable, Hashable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue.lowercased()
    }
}
