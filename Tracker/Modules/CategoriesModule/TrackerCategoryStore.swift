//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Антон Кашников on 22.08.2023.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let trackerStore = TrackerStore()
    
    weak var delegate: CategoryViewController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    private func getExistingCategoryObject(_ trackerCategory: TrackerCategory) -> TrackerCategoryCoreData? {
        guard let existingCategoriesObjects = fetchedResultsController.fetchedObjects else {
            return nil
        }
        
        return existingCategoriesObjects.first {
            $0.name == trackerCategory.name
        }
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) {
        let trackerCategoryObject = TrackerCategoryCoreData(context: context)
        trackerCategoryObject.name = trackerCategory.name
        
        do {
            try context.save()
        } catch {
            print("decodingErrorInvalidTrackerCategory")
        }
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfObjects() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func getObjectAt(indexPath: IndexPath) -> TrackerCategoryCoreData {
        fetchedResultsController.object(at: indexPath)
    }
    
    func isFetchedObjectsEmpty() -> Bool {
        fetchedResultsController.fetchedObjects == nil
    }
    
    func makeTrackerCategory(from trackerObjectCategory: TrackerCategoryCoreData) -> TrackerCategory? {
        if let name = trackerObjectCategory.name {
            return TrackerCategory(name: name, trackers: [])
        }
        return nil
    }
    
    func setDelegate(_ delegate: CategoryViewController?) {
        self.delegate = delegate
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
