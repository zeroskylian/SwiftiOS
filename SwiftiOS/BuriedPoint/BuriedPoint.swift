//
//  BuriedPoint.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/17.
//

import Foundation
import GRDB



struct BuriedPoint {
    let point: String
    let target: String
    let action: String
    let actionType: String?
}

extension BuriedPoint: Databaseable {
    
    static var table_name: String = {
        let current = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: current)
    }()
    
    
    
    public enum Columns {
        static let point = Column(CodingKeys.point)
        static let target = Column(CodingKeys.target)
        static let action = Column(CodingKeys.action)
        static let actionType = Column(CodingKeys.actionType)
    }
    
    static func createOperation() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("create\(table_name)") { db in
            try db.create(table: table_name) { t in
                t.column(Columns.point.name, .text)
                t.column(Columns.target.name, .text)
                t.column(Columns.action.name, .text)
                t.column(Columns.actionType.name, .text)
            }
        }
        return migrator
    }
    
    static func migrators() -> [DatabaseMigrator] {
        []
    }
}
