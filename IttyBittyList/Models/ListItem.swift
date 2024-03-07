//
//  Option.swift
//  Fandangle
//
//  Created by Aaron Pearce on 10/02/24.
//

import Foundation
import GRDB
import CloudKit
import SwiftUI
import HomeKit
import Harmony

struct ListItem: HRecord, Identifiable {

    var id: UUID = UUID()
    var text: String
    var isCompleted: Bool
    var archivedRecordData: Data?

    var zoneID: CKRecordZone.ID {
        return CKRecordZone.ID(
            zoneName: "ListItem",
            ownerName: CKCurrentUserDefaultName
        )
    }

    var record: CKRecord {
        let encoder = CKRecordEncoder(zoneID: zoneID)
        return try! encoder.encode(self)
    }

    mutating func updateChanges(db: Database, ckRecord: CKRecord) throws {

        if let new = Self.parseFrom(record: ckRecord) {
            try self.updateChanges(db) { record in
                record.text = new.text
                record.isCompleted = new.isCompleted
                record.archivedRecordData = new.archivedRecordData
            }
        }

    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.id == rhs.id
    }
}
