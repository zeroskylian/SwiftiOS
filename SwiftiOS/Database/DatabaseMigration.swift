//
//  YunZhouDatabaseMigration.swift
//  Standard-iOS
//
//  Created by James on 2019/8/21.
//  Copyright © 2019 YunZhou. All rights reserved.
//

import Foundation
import SQLiteMigrationManager
import SQLite

public struct DatabaseMigration {
    public static func migrations() -> [Migration] {
        var migrations: [Migration] = [Migration]()
        return migrations
    }
}
