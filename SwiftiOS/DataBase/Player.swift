//
//  Player.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/11.
//

import Foundation
import GRDB

struct Player {
    var id: String
    var name: String
    var score: Int
    var address: String?
}

extension Player: Databaseable {
    
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .replace, update: .replace)
    
    static var table_name: String  = "Player"
    
    static func createOperation() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("create\(table_name)") { db in
            try db.create(table: table_name) { t in
                t.column(Columns.id.name, .text).primaryKey().notNull()
                t.column(Columns.name.name, .text)
                t.column(Columns.scord.name, .integer)
            }
        }
        return migrator
    }
    
    static func migrators() -> [DatabaseMigrator] {
        var array: [DatabaseMigrator] = []
        var migrator = DatabaseMigrator()
        migrator.registerMigration("alert\(table_name)1") { db in
            try db.alter(table: table_name, body: { (t) in
                t.add(column: Columns.address.name, .text)
            })
        }
        array.append(migrator)
        return array
    }
    
    
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let scord = Column(CodingKeys.score)
        static let address = Column(CodingKeys.address)
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        
    }
}



extension Player {
    static func insertRows() {
        var array: [Player] = []
        for i in 1 ..< 10 {
            let random = Int.random(in: 30 ..< 50)
            let p = Player(id: "\(i + random)" , name: "player\(random)", score: 0, address: "USA")
            array.append(p)
        }
        
    }
}
