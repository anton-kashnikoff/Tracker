//
//  DataHelper.swift
//  Tracker
//
//  Created by Антон Кашников on 07.08.2023.
//

final class DataHelper {
    var trackersViewController: TrackersViewController?
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        guard let trackersViewController else {
            print("Unable to find TrackersViewController")
            return
        }
        
        // If the created category already exists
        if let indexOfExistingCategory = trackersViewController.categories.firstIndex(where: { trackerCategory in
            trackerCategory.name == category.name
        }) {
            trackersViewController.categories[indexOfExistingCategory].trackers.append(tracker)
        } else {
            trackersViewController.categories.append(category)
        }
    }
}
