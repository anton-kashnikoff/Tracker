//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Антон Кашников on 03/09/2023.
//

import Foundation

final class TrackerViewModel {
    private let store: TrackerStore
    
    var onCategoryChange: Binding?
    var onScheduleChange: Binding?
    var onTrackerChange: Binding?
    
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
    
    func setPredicate(date dayOfWeek: String, text: String) {
        if text.isEmpty {
            store.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K != YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.isPinned))
        } else {
            store.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(%K CONTAINS[cd] %@) AND (%K CONTAINS[cd] %@) AND (%K != YES)", #keyPath(TrackerCoreData.schedule), dayOfWeek, #keyPath(TrackerCoreData.name), text, #keyPath(TrackerCoreData.isPinned))
        }
    }
    
    func setPredicate() {
        store.fetchedResultsControllerForPinnedTrackers.fetchRequest.predicate = NSPredicate(format: "%K == YES", #keyPath(TrackerCoreData.isPinned))
    }
    
    func performFetch() throws {
        try store.fetchedResultsControllerForPinnedTrackers.performFetch()
        print("PINNED")
        print(store.fetchedResultsControllerForPinnedTrackers.fetchedObjects)
        print("TRACKERS")
        try store.fetchedResultsController.performFetch()
        print(store.fetchedResultsController.fetchedObjects)
    }
    
//    func numberOfSections() -> Int {
//        store.numberOfSections()
//    }
    
//    func numberOfItemsInSection(_ section: Int) -> Int {
//        store.numberOfItemsInSection(section)
//    }
    
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
    
    func getNumberOfSections() -> Int {
        if isPinnedFetchedObjectsEmpty() {
            return store.numberOfSections()
        } else {
            return store.numberOfSections() + 1
        }
    }
    
    func makeString(from daysOfWeek: Set<Schedule.DayOfWeek>) -> String {
        store.makeString(from: daysOfWeek)
    }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
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
            //значит это по любому не закреплённый трекер
            let trackerObject = getObjectAt(indexPath: indexPath)
            print("SECTION TITLE.1")
            return trackerObject.category?.name
        } else if indexPath.section == 0 {
            // если есть закреплённые трекеры и у этого трекера секция = 0, то он закреплён
            print("SECTION TITLE.2")
            return "Закреплённые"
        } else {
            // если есть закреплённые трекеры и у этого трекера секция отличная от нуля, то он не закреплён
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            let trackerObject = getObjectAt(indexPath: newIndexPath)
            print("SECTION TITLE.3")
            return trackerObject.category?.name
        }
    }
    
    func getTrackerObject(at indexPath: IndexPath) -> TrackerCoreData {
        print("Все закреплённые трекеры = \(store.fetchedResultsControllerForPinnedTrackers.fetchedObjects)")
        print("Все остальные трекеры = \(store.fetchedResultsController.fetchedObjects)")
        if isPinnedFetchedObjectsEmpty() {
            //значит это по любому не закреплённый трекер
            print("Закреплённых нет")
            return getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // если есть закреплённые трекеры и у этого трекера секция = 0, то он закреплён
            print("Трекер закреплён")
            
            return getPinnedObjectAt(indexPath: indexPath)
        } else {
            // если есть закреплённые трекеры и у этого трекера секция отличная от нуля, то он не закреплён
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            print("Трекер не закреплён. Получаю трекер с newIndexPath = \(newIndexPath)")
            return getObjectAt(indexPath: newIndexPath)
        }
    }
    
    func getAll() -> [TrackerCoreData] {
        store.fetchedResultsController.fetchedObjects ?? []
    }
    
    func editTracker(at indexPath: IndexPath) {
        if isPinnedFetchedObjectsEmpty() {
            return store.editTracker(at: indexPath)
        } else if indexPath.section == 0 {
            return store.editPinnedTracker(at: indexPath)
        } else {
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            return store.editTracker(at: newIndexPath)
        }
    }
}
