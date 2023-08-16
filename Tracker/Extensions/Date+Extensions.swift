//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Антон Кашников on 10.08.2023.
//

import Foundation

extension Date {
    public var withZeroTime: Date {
        Calendar.current.startOfDay(for: self)
    }
}
