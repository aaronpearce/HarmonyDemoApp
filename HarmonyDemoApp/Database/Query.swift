//
//  Query.swift
//  HarmonyDemoApp
//
//  Created by Aaron Pearce on 15/06/23.
//

import GRDBQuery
import GRDB
import SwiftUI

private struct DatabaseQueueKey: EnvironmentKey {
    /// The default dbQueue is an empty in-memory database of players
    static var defaultValue: DatabaseReader { try! DatabaseQueue() }
}

public extension EnvironmentValues {
    var databaseReader: DatabaseReader {
        get { self[DatabaseQueueKey.self] }
        set { self[DatabaseQueueKey.self] = newValue }
    }

    // Could just do
//    var databaseReader: DatabaseReader {
//        //Return the shared value
//        Harmonic.current
//    }
}

public extension Query where Request.DatabaseContext == DatabaseReader {
    /// Convenience initializer for requests that feed from `AppDatabase`.
    ///
    init(_ request: Request) {
        self.init(request, in: \.databaseReader)
    }
}

