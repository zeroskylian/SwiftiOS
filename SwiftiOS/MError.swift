//
//  AppError.swift
//  Standard-iOS
//
//  Created by James on 2019/11/20.
//  Copyright © 2019 YunZhou. All rights reserved.
//

import Foundation

public struct AppError: Error, CustomStringConvertible {
    
    private(set) public var description: String
    
    public init(file: String = #file, function: String = #function, line: Int = #line) {
        description = "error at " + (file as NSString).lastPathComponent + ":\(line)"
    }
}

public struct MError: LocalizedError {
    
    private(set) var message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        return self.message
    }
}


