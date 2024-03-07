//
//  Migrator.swift
//  HomePass2
//
//  Created by Aaron Pearce on 14/06/23.
//

import GRDB

struct Migrator {

    static func make() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createOptions") { db in
            try db.create(table: "option") { t in
                t.column("id", .text).notNull().primaryKey()
                t.column("text", .text).notNull()
                // CloudKit
                t.column("archivedRecordData", .blob)
            }
        }

        return migrator
    }
}
