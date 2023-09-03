//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Антон Кашников on 03/09/2023.
//

import Foundation

final class TrackerViewModel {
    var onCategoryChange: Binding?
    var onScheduleChange: Binding?
    var onTrackerChange: Binding?
    
    private let store: TrackerStore
    
    init(store: TrackerStore) {
        self.store = store
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
    
    func setDelegate(_ delegate: TrackersViewController?) {
        store.setDelegate(delegate)
    }
    
    func isFetchedObjectsEmpty() -> Bool {
        store.isFetchedObjectsEmpty()
    }
    
    func setPredicate(date dayOfWeek: String, text: String) {
        if text.isEmpty {
            // фильтруем только по дате
            store.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), dayOfWeek)
        } else {
            // фильтр по дате и тексту
            store.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text)
        }
    }
    
    func performFetch() throws {
        try store.fetchedResultsController.performFetch()
    }
    
    func numberOfSections() -> Int {
        store.numberOfSections()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        store.numberOfItemsInSection(section)
    }
    
    func getObjectAt(indexPath: IndexPath) -> TrackerCoreData {
        store.getObjectAt(indexPath: indexPath)
    }
    
    func makeTracker(from trackerObject: TrackerCoreData) -> Tracker? {
        store.makeTracker(from: trackerObject)
    }
}
