//
//  DatabaseManager.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/10.
//

import Foundation
import GRDB

typealias Databaseable = Codable & FetchableRecord & MutablePersistableRecord

class DatabaseManager {
    
    static let shared: DatabaseManager = DatabaseManager()
    
    private let dbWriter: DatabaseWriter
    
    private init()  {
        do {
            let fileManager = FileManager()
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("database", isDirectory: true)
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            let dbURL = folderURL.appendingPathComponent("db.sqlite")
            let db = try DatabaseQueue(path: dbURL.path)
            print(dbURL)
            print(dbURL.path)
            self.dbWriter = db
        } catch  {
            fatalError("Unresolved error \(error)")
        }
    }
    
}
