//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Антон Кашников on 03/09/2023.
//

import Foundation

final class CategoriesViewModel {
    private let store: TrackerCategoryStore
    
    var categoryAddingBinding: Binding?
    
    init(store: TrackerCategoryStore) {
        self.store = store
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) {
        store.addNewTrackerCategory(trackerCategory)
        categoryAddingBinding?()
    }
    
    func isFetchedObjectsEmpty() -> Bool {
        store.isFetchedObjectsEmpty()
    }
    
    func numberOfObjects() -> Int {
        store.numberOfObjects()
    }
    
    func getObjectAt(indexPath: IndexPath) -> TrackerCategoryCoreData {
        store.getObjectAt(indexPath: indexPath)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        store.numberOfRowsInSection(section)
    }
    
    func makeTrackerCategory(from trackerObjectCategory: TrackerCategoryCoreData) -> TrackerCategory? {
        store.makeTrackerCategory(from: trackerObjectCategory)
    }
    
    func setDelegate(_ delegate: CategoryViewController?) {
        store.setDelegate(delegate)
    }
}
