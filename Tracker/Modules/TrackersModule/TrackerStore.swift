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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "category.name", cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    private func makeString(from daysOfWeek: Set<Schedule.DayOfWeek>) -> String {
        var daysArray = [String]()
        
        daysOfWeek.forEach { day in
            daysArray.append(day.rawValue)
        }
        
        return daysArray.joined(separator: ", ")
    }
    
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = uiColorMarshalling.getHEXString(from: tracker.color)
        trackerCoreData.schedule = makeString(from: tracker.schedule.daysOfWeek)
        trackerCoreData.category = category
        trackerCoreData.isPinned = false
        
        do {
            try context.save()
        } catch {
            print("Unable to save context")
        }
    }
    
    func makeTracker(from trackerObject: TrackerCoreData) -> Tracker? {
        if let id = trackerObject.id, let name = trackerObject.name, let emoji = trackerObject.emoji, let colorString = trackerObject.color, let scheduleString = trackerObject.schedule {
            let daysOfWeek = Set(scheduleString.components(separatedBy: ", ").compactMap {
                Schedule.DayOfWeek(rawValue: $0)
            })
            return Tracker(id: id, name: name, color: uiColorMarshalling.getColor(from: colorString), emoji: emoji, schedule: Schedule(daysOfWeek: daysOfWeek))
        }
        return nil
    }
    
    func numberOfSections() -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
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
            //значит это по любому не закреплённый трекер
            print("значит это по любому не закреплённый трекер")
            trackerObject = getObjectAt(indexPath: indexPath)
        } else if indexPath.section == 0 {
            // если есть закреплённые трекеры и у этого трекера секция = 0, то он закреплён
            print("если есть закреплённые трекеры и у этого трекера секция = 0, то он закреплён. indexPath = \(indexPath)")
            trackerObject = getPinnedObjectAt(indexPath: indexPath)
        } else {
            // если есть закреплённые трекеры и у этого трекера секция отличная от нуля, то он не закреплён
            
            let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
            print("если есть закреплённые трекеры и у этого трекера секция отличная от нуля, то он не закреплён. newindexPath = \(newIndexPath)")
            trackerObject = getObjectAt(indexPath: newIndexPath)
        }
        
        print("trackerObject = \(trackerObject)")
        trackerObject.isPinned = !trackerObject.isPinned
        
        do {
            try context.save()
        } catch {
            print("decodingErrorInvalidTrackerCategory")
        }
    }
    
    func isTrackerPinned(_ indexPath: IndexPath) -> Bool {
        let trackerObject = getObjectAt(indexPath: indexPath)
        return trackerObject.isPinned
    }
    
    func getCountOfAllPinnedTrackers() -> Int {
        fetchedResultsControllerForPinnedTrackers.fetchedObjects?.count ?? 0
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
