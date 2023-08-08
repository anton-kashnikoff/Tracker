//
//  DataHelper.swift
//  Tracker
//
//  Created by Антон Кашников on 07.08.2023.
//

import Foundation

final class DataHelper {
    var trackersViewController: TrackersViewController?
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        guard let trackersViewController else {
            print("addTracker - Unable to find TrackersViewController")
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
    
    func createTrackerRecord(for tracker: Tracker, date: Date) {
        guard let trackersViewController else {
            print("createTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        // If the created tracker record already exists
        if trackersViewController.completedTrackers.firstIndex(where: { trackerRecord in
            trackerRecord.id == tracker.id && trackerRecord.date == date
        }) == nil {
            trackersViewController.completedTrackers.append(TrackerRecord(id: tracker.id, date: date))
        }
    }
    
    func deleteTrackerRecord(for tracker: Tracker, date: Date) {
        guard let trackersViewController else {
            print("deleteTrackerRecord - Unable to find TrackersViewController")
            return
        }
        
        if let indexToRemove = trackersViewController.completedTrackers.firstIndex(where: { trackerRecord in
            trackerRecord.id == tracker.id && trackerRecord.date == date
        }) {
            trackersViewController.completedTrackers.remove(at: indexToRemove)
        }
    }
}
