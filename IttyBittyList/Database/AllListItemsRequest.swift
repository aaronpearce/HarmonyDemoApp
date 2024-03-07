//
//  HomeRequest.swift
//  HomePassConcept (iOS)
//
//  Created by Aaron Pearce on 26/01/22.
//

import Combine
import Foundation
import GRDB
import GRDBQuery
import Harmony

struct AllListItemsRequest: Queryable {
    // MARK: - Queryable Implementation
    
    static var defaultValue: [ListItem] { [] }

    func publisher(in databaseReader: DatabaseReader) -> AnyPublisher<[ListItem], Error> {
        ValueObservation
            .tracking(fetchValue(_:))
            .publisher(
                in: databaseReader,
                scheduling: .immediate)
            .eraseToAnyPublisher()
    }
    
    func fetchValue(_ db: Database) throws -> [ListItem] {
        try ListItem
            .fetchAll(db)
            .sorted { item1, item2 in
                item1.cloudKitCreationDate ?? .distantPast < item2.cloudKitCreationDate ?? .distantPast
            }
    }
}
