//
//  Migrator.swift
//  HarmonyDemoApp
//
//  Created by Aaron Pearce on 14/06/23.
//

import GRDB

struct Migrator {

    static func make() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createListItems") { db in
            try db.create(table: "listItem") { t in
                t.column("id", .text).notNull().primaryKey()
                t.column("text", .text).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)

                // CloudKit
                t.column("archivedRecordData", .blob)
            }
        }

        return migrator
    }
}
