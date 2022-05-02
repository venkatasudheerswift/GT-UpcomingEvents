//
//  Event.swift
//  UpcomingEvents
//
//  Created by Venkata Sudheer Muthineni on 5/1/22.
//

import Foundation

struct Event: Codable, Equatable {
    let title: String
    let start: Date
    let end: Date
    var conflict: Bool?
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool { lhs.start < rhs.start }
}

extension Event: CustomStringConvertible {
    var description: String {
        "Title: \(title) - Start: \(Formatter.custom.string(from: start)) - End: \(Formatter.custom.string(from: end))"
    }
}

extension Event {
    var interval: DateInterval { .init(start: start, end: end) }
    
    func intersects(with event: Event) -> Bool {
        interval.intersects(event.interval)
    }
}
