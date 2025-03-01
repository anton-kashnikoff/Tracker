//
//  TrackerRecordViewModel.swift
//  Tracker
//
//  Created by Антон Кашников on 03/09/2023.
//

import Foundation

final class TrackerRecordViewModel {
    private let store: TrackerRecordStore
    private let analyticsService = AnalyticsService()
    
    init(store: TrackerRecordStore) {
        self.store = store
    }
    
    func completeTrackerTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
        print("A report was sent by clicking on the tracker execution button.")
    }
    
    func performFetch() throws {
        try store.fetchedResultsController.performFetch()
    }
    
    func checkTrackerRecordForDate(_ date: Date, id: UUID) -> TrackerRecordState {
        store.checkTrackerRecordForDate(date, id: id)
    }
    
    func toggleTrackerRecord(_ trackerRecord: TrackerRecord, trackerRecordState: TrackerRecordState) {
        store.toggleTrackerRecord(trackerRecord, trackerRecordState: trackerRecordState)
    }
    
    func getCountOfCompletedDaysForTracker(_ trackerID: UUID) -> Int? {
        store.getCountOfCompletedDaysForTracker(trackerID)
    }
    
    func getTrackerRecordIDForDate(date: Date) -> [UUID] {
        store.getTrackerRecordIDForDate(date)
    }
}
