//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Антон Кашников on 03/09/2023.
//

import Foundation

final class TrackerViewModel {
    private let store: TrackerStore
    private let analyticsService = AnalyticsService()
    
    var onCategoryChange: Binding?
    var onScheduleChange: Binding?
    var onTrackerChange: Binding?
    
    init(store: TrackerStore) {
        self.store = store
    }
    
    func viewDidAppear() {
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    func viewDidDisappear() {
        analyticsService.report(event: "close", params: ["screen": "Main"])
    }
    
    func categorySelected() {
        onCategoryChange?()
    }
    
    func scheduleSelected() {
        onScheduleChange?()
    }
    
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        store.addNewTracker(tracker, to: category)
        onTrackerChange?()
    }
    
    func removeTracker(_ trackerObject: TrackerCoreData) {
        store.removeTracker(trackerObject)
    }
    
    func setDelegate(_ delegate: TrackersViewController?) {
        store.setDelegate(delegate)
    }
    
    func isFetchedObjectsEmpty() -> Bool {
        store.isFetchedObjectsEmpty()
    }
    
    func isPinnedFetchedObjectsEmpty() -> Bool {
        store.isPinnedFetchedObjectsEmpty()
    }
    
    func filterTrackersForDay(date dayOfWeek: String, text: String) {
        if text.isEmpty {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.isPinned)))
        } else {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.isPinned)))
        }
    }
    
    func filterAllTrackers(text: String) {
        if text.isEmpty {
            store.setPredicateForTrackers(NSPredicate(format: "%K == NO", #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "%K == YES", #keyPath(TrackerCoreData.isPinned)))
        } else {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K == NO)", #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K == YES)", #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.isPinned)))
        }
    }
    
    func filterCompletedTrackers(dayOfWeek: String, text: String, completedIDs: [UUID]) {
        if text.isEmpty {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K IN %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K IN %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
        } else {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND (%K IN %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND (%K IN %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
        }
    }
    
    func filterUncompletedTrackers(dayOfWeek: String, text: String, completedIDs: [UUID]) {
        if text.isEmpty {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND NOT (%K IN %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND NOT (%K IN %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
        } else {
            store.setPredicateForTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND NOT (%K IN %@) AND (%K == NO)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
            store.setPredicateForPinnedTrackers(NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND NOT (%K IN %@) AND (%K == YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.trackerID), completedIDs, #keyPath(TrackerCoreData.isPinned)))
        }
    }
    
    func performFetch() {
        do {
            try store.fetchedResultsControllerForPinnedTrackers.performFetch()
            try store.fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
    }
    
    func getObjectAt(indexPath: IndexPath) -> TrackerCoreData {
        store.getObjectAt(indexPath: indexPath)
    }
    
    func getPinnedObjectAt(indexPath: IndexPath) -> TrackerCoreData {
        store.getPinnedObjectAt(indexPath: indexPath)
    }
    
    func makeTracker(from trackerObject: TrackerCoreData) -> Tracker? {
        store.makeTracker(from: trackerObject)
    }
    
    func pinTracker(at indexPath: IndexPath) {
        store.pinTracker(at: indexPath)
    }
    
    func isTrackerPinned(_ indexPath: IndexPath) -> Bool {
        store.isTrackerPinned(indexPath)
    }
    
    func getCountOfAllPinnedTrackers() -> Int {
        store.getCountOfAllPinnedTrackers()
    }
    
    func numberOfSections() -> Int {
        if isPinnedFetchedObjectsEmpty() {
            return store.numberOfSections()
        } else {
            return store.numberOfSections() + 1
        }
    }
    
    func makeString(from daysOfWeek: Set<Schedule.DayOfWeek>) -> String {
        store.makeString(from: daysOfWeek)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        if isPinnedFetchedObjectsEmpty() {
            return store.numberOfItemsInSection(section)
        } else {
            if section == 0 {
                return getCountOfAllPinnedTrackers()
            } else {
                return store.numberOfItemsInSection(section - 1)
            }
        }
    }
    
    func getSectionTitle(for indexPath: IndexPath) -> String? {
        if isPinnedFetchedObjectsEmpty() {
            // it's not a pinned tracker anyway
            let trackerObject = getObjectAt(indexPath: indexPath)
            return trackerObject.category?.name
        } else if indexPath.section == 0 {
            // if there are pinned trackers and this tracker has section = 0, then it is pinned
            return NSLocalizedString("pinned", comment: "Title for pinned trackers section")
        } else {
            // if there are pinned trackers and this tracker has a section other than zero, then it's not pinned
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            let trackerObject = getObjectAt(indexPath: newIndexPath)
            return trackerObject.category?.name
        }
    }
    
    func getTrackerObject(at indexPath: IndexPath) -> TrackerCoreData {
        if isPinnedFetchedObjectsEmpty() {
            // it's not a pinned tracker anyway
            return getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // if there are pinned trackers and this tracker has section = 0, then it is pinned
            return getPinnedObjectAt(indexPath: indexPath)
        } else {
            // if there are pinned trackers and this tracker has a section other than zero, then it's not pinned
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            return getObjectAt(indexPath: newIndexPath)
        }
    }
    
    func getAllTrackerIDs() -> [UUID] {
        store.getAllTrackerIDs()
    }
    
    func deleteTrackerTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
    }
    
    func addTrackerTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
    }
    
    func editTrackerTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
    }
    
    func filtersTapped() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
    }
}
