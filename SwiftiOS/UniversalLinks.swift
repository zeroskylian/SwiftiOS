//
//  Constants.swift
//  Moments
//
//  Created by Jake Lin on 3/2/21.
//

import Foundation

public struct UniversalLinks {
    // swiftlint:disable no_hardcoded_strings
    public static let baseURL = "https://m.henglink.com/ioslink"
    // swiftlint:enable no_hardcoded_strings
    public static func generatePath(path: NavigatorPath) -> String {
        return baseURL + "/" + path.rawValue
    }
    
}
