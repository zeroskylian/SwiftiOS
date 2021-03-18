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
        DataBaseCreation.addTarget(Player.self)
        DataBaseCreation.addTarget(BuriedPoint.self)
        DataBaseCreation.targets.forEach { (creation) in
            do {
                try creation.migrate(self.dbQueue)
            }catch {
                print(error)
            }
        }
    }
    
    private func migrationTables() {
        DatabaseMigration.addTarget(Player.self)
        DatabaseMigration.targets.forEach { migrator in
            do {
                try migrator.migrate(self.dbQueue)
            }catch {
                print(error)
            }
        }
    }
}

public class DataBaseCreation {
    
    private static var list: [DatabaseMigrator] = []
    private static let databaseLock = NSLock()
    
    public static func addTarget(_ target: DatabaseProtocol.Type) {
        databaseLock.lock()
        list.append(target.createOperation())
        databaseLock.unlock()
    }
    
    public static var targets: [DatabaseMigrator] {
        return list
    }
}

public class DatabaseMigration {
    
    private static var list: [DatabaseMigrator] = []
    private static let databaseLock = NSLock()
    
    public static func addTarget(_ target: DatabaseProtocol.Type) {
        databaseLock.lock()
        list.append(contentsOf: target.migrators())
        databaseLock.unlock()
    }
    
    public static var targets: [DatabaseMigrator] {
        return list
    }
}
