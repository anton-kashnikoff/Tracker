//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Антон Кашников on 22.08.2023.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: TrackersViewController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError  {
            print("Error: \(error)")
        }
    }
    
    func checkTrackerRecordForDate(_ date: Date, id: UUID) -> TrackerRecordState {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        
        performFetch()
        
        if let objects = fetchedResultsController.fetchedObjects {
            for object in objects {
                if object.date == date {
                    return .existForDate
                }
            }
        }
        
        return .notExist
    }
    
    func getTrackerRecordIDForDate(_ date: Date) -> [UUID] {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as CVarArg)
        
        performFetch()
        
        guard let ids = fetchedResultsController.fetchedObjects?.compactMap({
            $0.trackerID
        }) else {
            return []
        }
        
        return ids
    }
    
    func toggleTrackerRecord(_ trackerRecord: TrackerRecord, trackerRecordState: TrackerRecordState) {
        switch trackerRecordState {
        case .existForDate:
            if let objects = fetchedResultsController.fetchedObjects {
                for object in objects {
                    if object.date == trackerRecord.date {
                        context.delete(object)
                        continue
                    }
                }
            }
        case .notExist:
            let newTrackerRecordObject = TrackerRecordCoreData(context: context)
            newTrackerRecordObject.trackerID = trackerRecord.id
            newTrackerRecordObject.date = trackerRecord.date
        }
        
        do {
            try context.save()
        } catch {
            print("Unable to save context")
        }
    }
    
    func getCountOfCompletedDaysForTracker(_ trackerID: UUID) -> Int? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), trackerID as CVarArg)
        
        performFetch()
        
        return fetchedResultsController.fetchedObjects?.count
    }
    
    func setPredicateForTrackers(_ predicate: NSPredicate?) {
        fetchedResultsController.fetchRequest.predicate = predicate
    }
    
//    func setPredicateForPinnedTrackers(_ predicate: NSPredicate?) {
//        fetchedResultsControllerForPinnedTrackers.fetchRequest.predicate = predicate
//    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
