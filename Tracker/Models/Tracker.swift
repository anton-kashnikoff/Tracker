//
//  Tracker.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

import UIKit

protocol TrackerProtocol {
    var id: UUID { get }
    var name: String { get }
    var color: UIColor { get }
    var emoji: String { get }
    var schedule: Schedule { get }
}

struct Tracker: TrackerProtocol {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
}
