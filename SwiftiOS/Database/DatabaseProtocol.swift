//
//  YunZhouDBTransfer.swift
//  YunZhouDatabase
//
//  Created by James on 2018/5/2.
//  Copyright ©2018年 YunZhou. All rights reserved.
//

import Foundation
import SQLite

public typealias DatabaseClosure<T> = (Table) -> T

public typealias CompleteClosure<T> = (T) -> Void

private let databaseQueue = DispatchQueue(label: "Database_Queue")

private let completeQueue = DispatchQueue(label: "Complete_Queue")

// MARK: 以下方法中的执行顺序是同步的优先于异步执行, 当同步的全部执行完毕后, 异步的方法按照调用的顺序依次执行
public protocol DatabaseProtocol {
    
    static var table_name: Table { get set }
    
    static func createOperation()
}

// MARK: 该Extension中为异步方法, 只需要类型支持当前的DatabaseProtocol就可以使用了
extension DatabaseProtocol {
    
    public static func selectOperation(_ select: QueryType = table_name, complection: @escaping CompleteClosure<AnySequence<Row>?>, queue: DispatchQueue = DispatchQueue.main) {
        let operation = DatabaseOperation.select(select, complection)
        operation.excuteDatabaseOperation(queue: queue)
    }
    
    public static func insertOperation(_ insert: Insert, complection: CompleteClosure<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        let operation = DatabaseOperation.insert(insert, complection)
        operation.excuteDatabaseOperation(queue: queue)
    }
    
    public static func deleteOperation(_ delete: Delete, complection: CompleteClosure<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        let operation = DatabaseOperation.delete(delete, complection)
        operation.excuteDatabaseOperation(queue: queue)
    }
    
    public static func updateOperation(_ update: Update, complection: CompleteClosure<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        let operation = DatabaseOperation.update(update, complection)
        operation.excuteDatabaseOperation(queue: queue)
    }
}

// MARK: 该Extension中为同步方法, 只需要类型支持当前的DatabaseProtocol就可以使用了
extension DatabaseProtocol  {
    
    public static func selectOperation(_ select: QueryType = table_name, databaseManager : DatabaseManager = DatabaseManager.shared) -> AnySequence<Row>? {
        return databaseQueue.sync {
            return databaseManager.runSelect(with: select)
        }
    }
    @discardableResult
    public static func insertOperation(_ insert: Insert, databaseManager : DatabaseManager = DatabaseManager.shared) -> Bool {
        return databaseQueue.sync {
            return databaseManager.runInsert(with: insert)
        }
    }
    @discardableResult
    public static func updateOperation(_ update: Update, databaseManager : DatabaseManager = DatabaseManager.shared) -> Bool {
        return databaseQueue.sync {
            return databaseManager.runUpdate(with: update)
        }
    }
    @discardableResult
    public static func deleteOperation(_ delete: Delete, databaseManager : DatabaseManager = DatabaseManager.shared) -> Bool {
        return databaseQueue.sync {
            return databaseManager.runDelete(with: delete)
        }
    }
}

// MARK: 该Extension中有返回值得为同步方法, 没有返回值得为异步方法, 使用这些方法需要同时支持DatabaseProtocol和Codable协议
extension DatabaseProtocol where Self: Codable {
    @discardableResult
    public static func updateObject(with object: Self, query: QueryType, databaseManager : DatabaseManager = DatabaseManager.shared) -> Bool {
        return databaseQueue.sync {
            do {
                let update = try query.update(object)
                return databaseManager.runUpdate(with: update)
            } catch {
                return handleDBProtocolError(error)
            }
        }
    }
    @discardableResult
    public static func insertObject(with object: Self ,databaseManager : DatabaseManager = DatabaseManager.shared) -> Bool {
        return databaseQueue.sync {
            do {
                let insert = try table_name.insert(object)
                return databaseManager.runInsert(with: insert)
            } catch {
                return handleDBProtocolError(error)
            }
        }
    }
    
    
    
    public static func selectObject(with select: QueryType = table_name ,databaseManager : DatabaseManager = DatabaseManager.shared) -> [Self]? {
        return databaseQueue.sync {
            let sequence = databaseManager.runSelect(with: select)
            do {
                let list = try sequence.unwrap()
                return try list.map({ try $0.decode() })
            } catch {
                return handleDBProtocolError(error: error)
            }
        }
    }
    
    public static func selectOperator(_ select: QueryType = table_name, complection: @escaping CompleteClosure<[Self]?>, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = DatabaseOperation.select(select, { (sequence) in
                do {
                    let list = try sequence.unwrap()
                    complection( try list.map({ try $0.decode() }))
                } catch {
                    complection(handleDBProtocolError(error: error))
                }
            })
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func updateOperator(_ object: Self, query: QueryType, complection: CompleteClosure<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            do {
                let update = try query.update(object)
                let operation = DatabaseOperation.update(update, complection)
                operation.excuteDatabaseOperation(queue: queue)
            } catch {
                Logger.failure.message(error)
            }
        }
    }
    
    public static func insertOperator(_ object: Self, complection: CompleteClosure<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            do {
                let insert = try table_name.insert(object)
                let operation = DatabaseOperation.insert(insert, complection)
                operation.excuteDatabaseOperation(queue: queue)
            } catch {
                Logger.failure.message(error)
            }
        }
    }
}

fileprivate func handleDBProtocolError(_ error: Error) -> Bool {
    Logger.failure.message(error)
    return false
}

fileprivate func handleDBProtocolError<T>(error: Error) -> T? {
    return Logger.failure.allowNil(error)
}

fileprivate enum DatabaseOperation {
    case select(_ operation: QueryType, _ complection: CompleteClosure<AnySequence<Row>?>?)
    case insert(_ operation: Insert, _ complection: CompleteClosure<Bool>?)
    case delete(_ operation: Delete, _ complection: CompleteClosure<Bool>?)
    case update(_ operation: Update, _ complection: CompleteClosure<Bool>?)
}

extension DatabaseOperation {
    fileprivate func excuteDatabaseOperation(queue: DispatchQueue ,databaseManager : DatabaseManager = DatabaseManager.shared) {
        completeQueue.async {
            switch self {
            case .select (let operation, let closure):
                let sequence = databaseManager.runSelect(with: operation)
                self.completeOperation(closure, result: sequence, on: queue)
            case .insert (let operation, let closure):
                let isSuccess = databaseManager.runInsert(with: operation)
                self.completeOperation(closure, result: isSuccess, on: queue)
            case .delete (let operation, let closure):
                let isSuccess = databaseManager.runDelete(with: operation)
                self.completeOperation(closure, result: isSuccess, on: queue)
            case .update (let operation, let closure):
                let isSuccess = databaseManager.runUpdate(with: operation)
                self.completeOperation(closure, result: isSuccess, on: queue)
            }
        }
    }
    private func completeOperation<T> (_ closure: CompleteClosure<T>?, result: T, on currentQueue: DispatchQueue) {
        currentQueue.sync { closure?(result) }
    }
}
