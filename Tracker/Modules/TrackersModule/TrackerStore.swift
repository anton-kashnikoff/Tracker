//
//  TrackerStore.swift
//  Tracker
//
//  Created by Антон Кашников on 22.08.2023.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    weak var delegate: TrackersViewController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "category.name", cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    lazy var fetchedResultsControllerForPinnedTrackers: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Unable to save context")
        }
    }
    
    func makeString(from daysOfWeek: Set<Schedule.DayOfWeek>) -> String {
        var daysArray = [String]()
        
        daysOfWeek.forEach { day in
            daysArray.append(day.rawValue)
        }
        
        return daysArray.joined(separator: ", ")
    }
    
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = uiColorMarshalling.getHEXString(from: tracker.color)
        trackerCoreData.schedule = makeString(from: tracker.schedule.daysOfWeek)
        trackerCoreData.category = category
        trackerCoreData.isPinned = false
        
        saveContext()
    }
    
    func removeTracker(_ trackerObject: TrackerCoreData) {
        context.delete(trackerObject)
        saveContext()
    }
    
    func makeTracker(from trackerObject: TrackerCoreData) -> Tracker? {
        if let id = trackerObject.trackerID, let name = trackerObject.name, let emoji = trackerObject.emoji, let colorString = trackerObject.color, let scheduleString = trackerObject.schedule {
            let daysOfWeek = Set(
                scheduleString.components(
                    separatedBy: ", "
                ).compactMap {
                    Schedule.DayOfWeek(rawValue: $0)
                }
            )
            return Tracker(id: id, name: name, color: uiColorMarshalling.getColor(from: colorString), emoji: emoji, schedule: Schedule(daysOfWeek: daysOfWeek))
        }
        return nil
    }
    
    func numberOfSections() -> Int {
        fetchedResultsController.sections?.count ?? .zero
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? .zero
    }
    
    func getObjectAt(indexPath: IndexPath) -> TrackerCoreData {
        fetchedResultsController.object(at: indexPath)
    }
    
    func getPinnedObjectAt(indexPath: IndexPath) -> TrackerCoreData {
        fetchedResultsControllerForPinnedTrackers.object(at: indexPath)
    }
    
    func isFetchedObjectsEmpty() -> Bool {
        fetchedResultsController.fetchedObjects == nil || fetchedResultsController.fetchedObjects == []
    }
    
    func isPinnedFetchedObjectsEmpty() -> Bool {
        fetchedResultsControllerForPinnedTrackers.fetchedObjects == nil || fetchedResultsControllerForPinnedTrackers.fetchedObjects == []
    }
    
    func setDelegate(_ delegate: TrackersViewController?) {
        self.delegate = delegate
    }
    
    func pinTracker(at indexPath: IndexPath) {
        var trackerObject: TrackerCoreData
        
        if isPinnedFetchedObjectsEmpty() {
            // it's not a pinned tracker anyway
            trackerObject = getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // if there are pinned trackers and this tracker has section = 0, then it is pinned
            trackerObject = getPinnedObjectAt(indexPath: indexPath)
        } else {
            // if there are pinned trackers and this tracker has a section other than zero, then it's not pinned
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            trackerObject = getObjectAt(indexPath: newIndexPath)
        }
        
        trackerObject.isPinned = !trackerObject.isPinned
        
        saveContext()
    }
    
    func isTrackerPinned(_ indexPath: IndexPath) -> Bool {
        getObjectAt(indexPath: indexPath).isPinned
    }
    
    func getCountOfAllPinnedTrackers() -> Int {
        fetchedResultsControllerForPinnedTrackers.fetchedObjects?.count ?? .zero
    }
    
    func getAllTrackerIDs() -> [UUID] {
        // TODO: Maybe redo using request
        guard let trackerObjects = fetchedResultsController.fetchedObjects, let pinnedTrackerObjects = fetchedResultsControllerForPinnedTrackers.fetchedObjects else {
            return []
        }
        
        var trackersIDs = [UUID]()
        
        for object in trackerObjects {
            guard let id = object.trackerID else {
                return []
            }
            
            trackersIDs.append(id)
        }
        
        for object in pinnedTrackerObjects {
            guard let id = object.trackerID else {
                return []
            }
            
            trackersIDs.append(id)
        }
        
        return trackersIDs
    }
    
    func setPredicateForTrackers(_ predicate: NSPredicate?) {
        fetchedResultsController.fetchRequest.predicate = predicate
    }
    
    func setPredicateForPinnedTrackers(_ predicate: NSPredicate?) {
        fetchedResultsControllerForPinnedTrackers.fetchRequest.predicate = predicate
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
