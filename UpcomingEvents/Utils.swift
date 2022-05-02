//
//  Utils.swift
//  UpcomingEvents
//
//  Created by Venkata Sudheer Muthineni on 5/1/22.
//

import Foundation

//MARK: Helper method to load mock json file.
func loadJson(fileName: String) -> [Event]? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .monthDayYearTime
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          var events = try? decoder.decode([Event].self, from: data) else {
              return nil
          }
    
    let conflictingEvents: [(Event, Event)] = events.compactMap {
        for event in events where event != $0 {
            if event.intersects(with: $0) && $0.end != event.start && event.end != $0.start {
                return ($0, event)
            }
        }
        return nil
    }

    for event in conflictingEvents {
        if let index = events.firstIndex(of: event.0) {
            events[index].conflict = true
        }
        if let index = events.firstIndex(of: event.1) {
            events[index].conflict = true
        }
    }

    events.sort { (($0.start).compare($1.start)) == .orderedAscending }
    return events
}

//MARK: Date Formatting
extension Formatter {
    static let custom: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM d, yyyy h:mm a"
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let monthDayYearTime = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.custom.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}
