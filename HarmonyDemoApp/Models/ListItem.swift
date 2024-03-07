//
//  ListItem.swift
//  HarmonyDemoApp
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.id == rhs.id
    }
}
