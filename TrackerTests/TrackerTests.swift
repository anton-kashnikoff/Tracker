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
    func testTrackerViewControllerLight() {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackerViewControllerDark() {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}
