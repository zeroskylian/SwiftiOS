//
//  DataBaseProtocol.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/15.
//

import Foundation
import GRDB

typealias Databaseable = Codable & FetchableRecord & MutablePersistableRecord & DatabaseProtocol

public typealias DatabaseResult = Result<Void,Error>

public protocol DatabaseProtocol {
    
    static var table_name: String { get }
    
    static func createOperation() -> DatabaseMigrator
    
    static func migrators() -> [DatabaseMigrator]
    
    
}

extension Result where Success == Void {
    public static func success() -> Self { .success(()) }
}

extension FetchableRecord where Self: MutablePersistableRecord {
    
    @discardableResult
    mutating func insertRow() -> DatabaseResult {
        do {
            try DatabaseManager.shared.dbQueue.inTransaction(.deferred, { (db) -> Database.TransactionCompletion in
                return .commit
            })
            return try DatabaseManager.shared.dbQueue.write { (dataBase) -> DatabaseResult in
                try self.insert(dataBase)
                return .success()
            }
        } catch  {
            return .failure(error)
        }
    }
    
    @discardableResult
    mutating func update() -> DatabaseResult {
        do {
            return try DatabaseManager.shared.dbQueue.write { (dataBase) -> DatabaseResult in
                try self.insert(dataBase)
                return .success()
            }
        } catch  {
            return .failure(error)
        }
    }
    
    mutating func delete(_ sql: GRDB.SQLSpecificExpressible) -> DatabaseResult {
        do {
            return try DatabaseManager.shared.dbQueue.write { (dataBase) -> DatabaseResult in
                try self.delete(dataBase)
                return .success()
            }
        } catch  {
            return .failure(error)
        }
    }
    
    static func select(_ sql: GRDB.SQLSpecificExpressible) -> Self? {
        do {
            return try DatabaseManager.shared.dbQueue.read({ (db) in
                return try self.filter(sql).fetchOne(db)
            })
        } catch  {
            return nil
        }
    }
    
    static func selectAll(_ sql: GRDB.SQLSpecificExpressible) -> [Self] {
        do {
            return try DatabaseManager.shared.dbQueue.read({ (db) in
                return try self.filter(sql).fetchAll(db)
            })
        } catch  {
            return []
        }
    }
    
}

extension Array where Element: Databaseable {
    func insert() {
        do {
            try DatabaseManager.shared.dbQueue.inTransaction(.immediate) { (db) -> Database.TransactionCompletion in
                do {
                    for var item in self {
                        try item.insert(db)
                    }
                    return .commit
                }catch {
                    print(error)
                    return .rollback
                }
            }
        } catch  {
            print(error)
        }
    }
}
