//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Антон Кашников on 22.08.2023.
//

import UIKit
import CoreData

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
    
    func checkTrackerRecordForDate(_ date: Date, id: UUID) -> TrackerRecordState {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError  {
            print("Error: \(error)")
        }
        
        if let objects = fetchedResultsController.fetchedObjects {
            for object in objects {
                if object.date == date {
                    return .existForDate
                }
            }
        }
        
        return .notExist
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
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError  {
            print("Error: \(error)")
        }
        
        return fetchedResultsController.fetchedObjects?.count
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
