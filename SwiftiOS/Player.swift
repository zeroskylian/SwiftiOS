//
//  Player.swift
//  SwiftiOS
//
//  Created by lian on 2021/3/11.
//

import Foundation
import GRDB

struct Player {
    var id: Int64?
    var name: String
    var score: Int
}

extension Player: Databaseable {
    
}
