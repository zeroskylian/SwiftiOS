//
//  DatabaseManager.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/10.
//

import Foundation
import GRDB

class DatabaseManager {
    
    static let shared: DatabaseManager = DatabaseManager()
    
    public let dbQueue: DatabaseQueue
    
    private init()  {
        do {
            let fileManager = FileManager()
            let folderURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) .appendingPathComponent("database", isDirectory: true)
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            let dbURL = folderURL.appendingPathComponent("db.sqlite")
            let db = try DatabaseQueue(path: dbURL.path)
            print(dbURL.path)
            self.dbQueue = db
        } catch  {
            fatalError("Unresolved error \(error)")
        }
    }
    
    public func setup() {
        registerTables()
        migrationTables()
    }
    
    
    private func registerTables() {
        DatabaseMigration.creation.addTarget(Player.self)
        DatabaseMigration.creation.addTarget(BuriedPoint.self)
        DatabaseMigration.creation.targets.forEach { (creation) in
            do {
                try creation.migrate(self.dbQueue)
            }catch {
                print(error)
            }
        }
    }
    
    private func migrationTables() {
        DatabaseMigration.migration.addTarget(Player.self)
        DatabaseMigration.migration.targets.forEach { migrator in
            do {
                try migrator.migrate(self.dbQueue)
            }catch {
                print(error)
            }
        }
    }
}


public class DatabaseMigration {
    
    public static let creation = DatabaseMigration()
    
    public static let migration = DatabaseMigration()
    
    private var list: [DatabaseMigrator] = []
    private let databaseLock = NSLock()
    
    public func addTarget(_ target: DatabaseProtocol.Type) {
        databaseLock.lock()
        list.append(contentsOf: target.migrators())
        databaseLock.unlock()
    }
    
    public var targets: [DatabaseMigrator] {
        return list
    }
}
