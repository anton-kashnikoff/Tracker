//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Антон Кашников on 17/09/2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackerViewController() {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image])
    }
}
