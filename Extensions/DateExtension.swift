//
//  DateExtension.swift
//  HabitsGenerator
//
//  Created by Pogosian on 7/23/21.
//

import Foundation

extension Date {
    var startOfWeek: Date {
            let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
            let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
            return date.addingTimeInterval(dslTimeOffset)
        }

        var endOfWeek: Date {
            return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
        }
}
