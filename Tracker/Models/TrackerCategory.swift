//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

protocol TrackerCategoryProtocol {
    var name: String { get }
    var trackers: [Tracker] { get }
}

struct TrackerCategory: TrackerCategoryProtocol {
    let name: String
    var trackers: [Tracker]
}
