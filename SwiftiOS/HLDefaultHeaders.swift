//
//  HLDefaultHeaders.swift
//  HengLiMarketing
//
//  Created by lian on 2021/4/6.
//
import Foundation
import HLLoggerModule

public func HLLog<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
    Logger(message: message, type: Logger<T>.LogType.bridges, level: .debug, file: file, method: method, line: line)
}

public func HLLog<T>(message: T, type: Logger<T>.LogType, level: LogUtility = .debug, file: String = #file, method: String = #function, line: Int = #line) {
    Logger(message: message, type: type, level: level, file: file, method: method, line: line)
}

/// 加锁
/// - Parameters:
///   - lock: 锁住
///   - closure: 操作
/// - Throws: 可能抛出异常
/// - Returns: 结果
public func synchronized<T>(_ lock: AnyObject, _ closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try closure()
}

/// 线程安全
/// - Parameter block: 操作
/// - Returns: 无
public func threadSafe(block: @escaping () -> Void) {
    if Thread.current == .main {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

/// 配置方法
/// - Parameters:
///   - object: 对象
///   - closure: 参数
/// - Returns: 返回值
public func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
