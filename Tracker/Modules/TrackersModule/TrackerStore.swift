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
    
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = uiColorMarshalling.getHEXString(from: tracker.color)
        trackerCoreData.schedule = makeString(from: tracker.schedule.daysOfWeek)
        trackerCoreData.category = category
        
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
    
    private func makeString(from daysOfWeek: Set<Schedule.DayOfWeek>) -> String {
        var daysArray = [String]()
        
        daysOfWeek.forEach { day in
            daysArray.append(day.rawValue)
        }
        
        return daysArray.joined(separator: ", ")
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
    
    func isFetchedObjectsEmpty() -> Bool {
        fetchedResultsController.fetchedObjects == nil || fetchedResultsController.fetchedObjects == []
    }
    
    func setDelegate(_ delegate: TrackersViewController?) {
        self.delegate = delegate
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
